# womeninrobotics.github.io

Community for women working in robotics, and women who want to work in robotics, and non-binary people.

Join a community of more than a thousand women and non-binary people working in robotics, in academia and industry, all over the world. We support local networking events, and raising the profile of women working in robotics globally. You can join our slack community by signing up [here](https://forms.gle/RKRNpKYWA2smGW2c9)

Come back soon because we're updating this site with some exciting new services and information. Want to help? volunteer@womeninrobotics.org

## Contributing

See our [Contributing guide](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

### Site organization

* `_data`: General information for the site
* `_includes`: HTML snippets used in layouts
* `_layouts`: Layout templates used for the site
* `_posts`: Dated content used for news snippets
* `.devcontainer`: VSCode docker environment
* `.github`: Github action workflows and settings
* `.vscode`: VSCode IDE settings
* `assets`: Website assets that should be deployed
* `pages`: Subpages of the website

### FAQ

#### How to add a chapter

Update `_data/chapters.yaml` to add or edit chapter info

Format:

```yaml
Region: # This is the chapter region heading
  - name: # The location of the chapter
    url: # The url for the chapter
  - name: # The location of the chapter
    url: # The url for the chapter
```

#### How to add an event

Events are updated from [meetingplace.io](https://meetingplace.io/) in the [meetingplace workflow action](.github/workflows/meetinplace.yaml).

To add another group, add an additional line like:

```yaml
      - name: Get bay area events
        run: curl -s 'https://meetingplace.io/api/v1/group/women-in-robotics-bay-area/events' | jq '.' > _data/wir_events_bay_area.json
```

where `women-in-robotics-bay-area` is replaced by the new group name and it's saved in a file named for the area like `_data/wir_events_bay_area.json`.

It is important that the file begins with `wir_events`, since that prefix is used to determine which events to combine.

#### How to change shop items shown

Update `_data/shop.yaml` to change shop item thumbnails

Format:

```yaml
- image: /assets/images/shop/<image_name>.jpg
```

#### How to add a news article

Add a news article by adding a new file in `_posts`.   The filename should be formatted as `YYYY-mm-dd-title.md`.  The content of the file should have the following frontmatter:

```yaml
---
layout: default
title: # your title
image: # thumbnail image
link: https://robohub.org/25-women-in-robotics-you-need-to-know-about/
---
```

#### How to add a news article with content

If you want to publish an article from this website, just point the link to the article's URL or permalink.

example:

```md
---
layout: default
title: # your title
image: # thumbnail image
link: #/YYYY/mm/dd/title.html
---

# Your article title

Some content!  All articles are written in [markdown](https://www.markdownguide.org/)
```
