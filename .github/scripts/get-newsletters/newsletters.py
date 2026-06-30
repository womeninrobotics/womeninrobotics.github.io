#!/usr/bin/env python3
import argparse
import html
import os
import re
import sys
import unicodedata
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from datetime import timezone
from email.utils import parsedate_to_datetime
from html.parser import HTMLParser
from pathlib import Path


FRONT_MATTER_RE = re.compile(r"\A---\n(.*?)\n---", re.DOTALL)
LINK_RE = re.compile(r"^link:\s*(.+?)\s*$", re.MULTILINE)
TITLE_RE = re.compile(r"^title:\s*(.+?)\s*$", re.MULTILINE)
IMG_RE = re.compile(r"<img[^>]+src=[\"']([^\"']+)[\"']", re.IGNORECASE)
MEDIA_NS = "{http://search.yahoo.com/mrss/}"
CONTENT_NS = "{http://purl.org/rss/1.0/modules/content/}"
USER_AGENT = (
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
)


class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []

    def handle_data(self, data):
        if data.strip():
            self.parts.append(data.strip())

    def text(self):
        return " ".join(self.parts)


def canonical_url(url):
    parsed = urllib.parse.urlparse(url.strip())
    netloc = parsed.netloc
    path = parsed.path.rstrip("/")
    if netloc == "open.substack.com" and path.startswith("/pub/womeninrobotics/"):
        netloc = "womeninrobotics.substack.com"
        path = path.removeprefix("/pub/womeninrobotics")
    elif netloc == "www.womeninrobotics.org":
        netloc = "womeninrobotics.org"
    return urllib.parse.urlunparse((parsed.scheme, netloc, path, "", "", ""))


def title_key(title):
    words = re.findall(r"[a-z0-9]+", title.lower())
    return " ".join(sorted(words))


def parse_post_date(path):
    match = re.match(r"(\d{4}-\d{2}-\d{2})-", path.name)
    return match.group(1) if match else ""


def yaml_value(value):
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] == '"':
        return value[1:-1].replace('\\"', '"').replace("\\\\", "\\")
    return value


def existing_posts(posts_dir):
    links = set()
    title_dates = set()
    filenames = set()
    for post in posts_dir.glob("*.md"):
        filenames.add(post.name)
        contents = post.read_text(encoding="utf-8")
        match = FRONT_MATTER_RE.search(contents)
        if not match:
            continue
        front_matter = match.group(1)
        link_match = LINK_RE.search(front_matter)
        if link_match:
            links.add(canonical_url(yaml_value(link_match.group(1))))
        title_match = TITLE_RE.search(front_matter)
        if title_match:
            title_dates.add((parse_post_date(post), title_key(yaml_value(title_match.group(1)))))
    return links, title_dates, filenames


def duplicate_item(item, date, filename, seen_links, seen_title_dates, seen_filenames):
    link = canonical_url(item_text(item, "link"))
    title = item_text(item, "title")
    return (
        link in seen_links
        or filename.name in seen_filenames
        or (date.isoformat(), title_key(title)) in seen_title_dates
    )


def normalize_url(url):
    url = url.strip()
    markdown_match = re.fullmatch(r"\[[^\]]+\]\((https?://[^)]+)\)", url)
    if markdown_match:
        return markdown_match.group(1)
    urls = re.findall(r"https?://[^\s)>]+", url)
    if urls:
        return urls[-1]
    return url.strip("<>")


def fetch_feed(feed_url, feed_file):
    if feed_file:
        return Path(feed_file).read_text(encoding="utf-8")

    feed_url = normalize_url(feed_url)
    request = urllib.request.Request(
        feed_url,
        headers={
            "User-Agent": USER_AGENT,
            "Accept": "application/rss+xml, application/xml;q=0.9, */*;q=0.8",
            "Accept-Language": "en-US,en;q=0.9",
        },
    )
    print(f"Fetching RSS feed: {feed_url}")
    with urllib.request.urlopen(request, timeout=30) as response:
        print("Fetched RSS feed.")
        return response.read().decode("utf-8")


def feed_items(feed_url, feed_file):
    root = ET.fromstring(fetch_feed(feed_url, feed_file))
    return root.findall("./channel/item")


def item_text(item, tag):
    value = item.findtext(tag)
    return html.unescape(value.strip()) if value else ""


def item_content(item):
    return item.findtext(f"{CONTENT_NS}encoded") or item_text(item, "description")


def item_image(item):
    media = item.find(f"{MEDIA_NS}content")
    if media is not None and media.get("url"):
        return media.get("url")

    match = IMG_RE.search(item_content(item))
    return html.unescape(match.group(1)) if match else ""


def item_tagline(item):
    extractor = TextExtractor()
    extractor.feed(item_text(item, "description"))
    text = re.sub(r"\s+", " ", extractor.text()).strip()
    if len(text) <= 180:
        return text
    return text[:177].rsplit(" ", 1)[0] + "..."


def item_date(item):
    pub_date = item_text(item, "pubDate")
    if not pub_date:
        raise ValueError(f"Feed item is missing pubDate: {item_text(item, 'title')}")
    parsed = parsedate_to_datetime(pub_date)
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=timezone.utc)
    return parsed.astimezone(timezone.utc).date()


def slugify(title):
    normalized = unicodedata.normalize("NFKD", title)
    ascii_title = normalized.encode("ascii", "ignore").decode("ascii")
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", ascii_title.lower()).strip("-")
    return slug[:80].rstrip("-") or "newsletter"


def yaml_string(value):
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def render_post(item):
    title = item_text(item, "title")
    link = item_text(item, "link")
    image = item_image(item)
    tagline = item_tagline(item)

    front_matter = [
        "---",
        f"title: {yaml_string(title)}",
    ]
    if image:
        front_matter.append(f"image: {yaml_string(image)}")
    front_matter.extend(
        [
            f"link: {yaml_string(link)}",
            f"tagline: {yaml_string(tagline)}",
            "---",
            "",
            f"[Read it on Substack]({link})" + "{: .btn .btn-lg .btn-default-filled .my-5}",
            "",
            '<div class="text-center">',
            '<iframe src="https://womeninrobotics.substack.com/embed" width="100%" height="320" style="background:white;" frameborder="0" scrolling="no"></iframe>',
            "</div>",
            "",
        ]
    )
    return "\n".join(front_matter)


def import_newsletters(feed_url, feed_file, posts_dir):
    posts_dir.mkdir(parents=True, exist_ok=True)
    seen_links, seen_title_dates, seen_filenames = existing_posts(posts_dir)
    created = []

    for item in feed_items(feed_url, feed_file):
        link = item_text(item, "link")
        if not link:
            continue

        date = item_date(item)
        title = item_text(item, "title")
        filename = posts_dir / f"{date.isoformat()}-{slugify(title)}.md"
        if duplicate_item(item, date, filename, seen_links, seen_title_dates, seen_filenames):
            continue

        filename.write_text(render_post(item), encoding="utf-8")
        seen_links.add(canonical_url(link))
        seen_title_dates.add((date.isoformat(), title_key(title)))
        seen_filenames.add(filename.name)
        created.append(filename)

    return created


def main():
    parser = argparse.ArgumentParser(description="Create Jekyll posts from a Substack RSS feed.")
    parser.add_argument(
        "--feed-url",
        default=os.environ.get("NEWSLETTER_FEED_URL", "https://womeninrobotics.substack.com/feed"),
    )
    parser.add_argument("--feed-file", help="Read RSS XML from a local file instead of fetching the feed.")
    parser.add_argument("--posts-dir", default="_posts")
    args = parser.parse_args()

    created = import_newsletters(args.feed_url, args.feed_file, Path(args.posts_dir))
    if created:
        print("Created newsletter posts:")
        for post in created:
            print(f"- {post}")
    else:
        print("No new newsletter posts.")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"Failed to import newsletters: {exc}", file=sys.stderr)
        sys.exit(1)
