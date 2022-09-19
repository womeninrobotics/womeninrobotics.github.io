# womeninrobotics.github.io

Community for women working in robotics, and women who want to work in robotics, and non-binary people.

Join a community of more than a thousand women and non-binary people working in robotics, in academia and industry, all over the world. We support local networking events, and raising the profile of women working in robotics globally. You can join our slack community by signing up [here](https://forms.gle/RKRNpKYWA2smGW2c9)

Come back soon because we're updating this site with some exciting new services and information. Want to help? volunteer@womeninrobotics.org

## Contributing

See our [Contributing guide](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

## Site organization

* `_data`: General information for the site
* `_includes`: HTML snippets used in layouts
* `_layouts`: Layout templates used for the site
* `_posts`: Dated content used for news snippets
* `.devcontainer`: VSCode docker environment
* `.github`: Github action workflows and settings
* `.vscode`: VSCode IDE settings
* `assets`: Website assets that should be deployed
* `pages`: Subpages of the website

## How to add a chapter

### Update chapter listing

Update `_data/chapters.json` to add or edit chapter info

Format:

```jsonc
[
  {
    "name": "Online", // Short name of the chapter
    "long_name": "Online", // Long name of the chapter, include region, state, or country if applicable
    "region": "Global", // Region to place the chapter in for the index
    "meetingplace": "womeninrobotics", // meetingplace id
    "slack": "events", // Name of the corresponding slack channel for the chapter, often local_<chapter name>
    "email": "online@womeninrobotics.org", // email address for the chapter
    "time": 15, // time offset for checking for new events
    "description": "Andra Keay\nLaura Stelzner" // Leaders for the chapter
  }
]
```

These values are updated from the [`Current Chapter Organizers`](https://docs.google.com/spreadsheets/d/1Z9iAIqHjX-nGQ3G9jNqXhYdm38QD7I1HmJVSlmf_d-E/edit?usp=sharing) file on the shared drive.

Updating this file will

1. Update the chapter list on the website [chapaters](https://www.womeninrobotics.org/chapters/)
2. Update the meetingplace.io scrapper
3. Update the [meetingplace slackbot](https://github.com/womeninrobotics/meetingplace-slack-bot) on [heroku](https://dashboard.heroku.com/apps/meetingplace-slack-bot
)

## How to change shop items

Update `_data/shop.yaml` to change shop item thumbnails

Format:

```yaml
- image: /assets/images/shop/<image_name>.jpg
```

## How to add a news article

Add a news article by adding a new file in `_posts`.   The filename should be formatted as `YYYY-mm-dd-title.md`.  The content of the file should have the following frontmatter:

```yaml
---
layout: default
title: # your title
image: # thumbnail image
link: # link to the article
---
```

### News article with content

If you want to publish an article from this website, just point the link to the article's URL or permalink.

example:

```md
---
layout: default
title: # your title
image: # thumbnail image
---

# Your article title

Some content!  All articles are written in [markdown](https://www.markdownguide.org/)
```
