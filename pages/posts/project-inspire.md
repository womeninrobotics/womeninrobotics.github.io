---
layout: post
title: Project Inspire
image: /assets/images/project-inspire-sm.jpg
permalink: /project-inspire/

infos:
  - title: "Newsletter"
    url: "/newsletter/"
    image: "/assets/images/wir-news.png"
    description: "Get inspiring women in robotics sent directly to you by signing up for our newsletter!"
  - title: "Annual list"
    url: "/annual-list/"
    image: "/assets/images/wir-annual-list.png"
    description: "In celebration of Ada Lovelace Day, we compile a short list every year of some women in robotics that everyone should know about."
  - title: "Photo challenge"
    url: "/photo-challenge/"
    image: "/assets/images/wir-photo-challenge.png"
    description: "How can women feel as if they belong in robotics if we can’t see any pictures of women building or programming robots? Join the challenge to showcase your talented women and other underrepresented groups!"
  - title: "Speaker Series"
    url: "/speaker-series/"
    image: "/assets/images/wir-speaker-series.png"
    description: "This speaker series focuses on the career journeys of some of the amazing women within our community."
  - title: "Ask me Anything"
    url: "/ama-series/"
    image: "/assets/images/wir-ask-me-anything.png"
    description: "In this interview series, anything goes!  Meet some of the exceptional women in our community."

---

## What is it

You can't be what you can't see.  Project Inspire is our initiative to promote the visibility of women in robotics.

## Be inspired

<div class="row">
{% for info in page.infos %}
{% include info-card.html info=info %}
{% endfor %}
</div>
