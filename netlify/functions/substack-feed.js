const SUBSTACK_FEED_URL = "https://womeninrobotics.substack.com/feed";

exports.handler = async function () {
  try {
    const response = await fetch(SUBSTACK_FEED_URL, {
      headers: {
        "User-Agent":
          "Mozilla/5.0 (compatible; WomenInRoboticsNewsletterImporter/1.0; +https://womeninrobotics.org)",
        Accept: "application/rss+xml, application/xml;q=0.9, */*;q=0.8",
        "Accept-Language": "en-US,en;q=0.9",
      },
    });

    if (!response.ok) {
      return {
        statusCode: response.status,
        headers: {
          "content-type": "text/plain; charset=utf-8",
          "cache-control": "no-store",
        },
        body: `Failed to fetch Substack feed: ${response.status}`,
      };
    }

    return {
      statusCode: 200,
      headers: {
        "content-type": "application/rss+xml; charset=utf-8",
        "cache-control": "public, max-age=900",
        "access-control-allow-origin": "*",
      },
      body: await response.text(),
    };
  } catch (error) {
    return {
      statusCode: 502,
      headers: {
        "content-type": "text/plain; charset=utf-8",
        "cache-control": "no-store",
      },
      body: `Failed to fetch Substack feed: ${error.message}`,
    };
  }
};
