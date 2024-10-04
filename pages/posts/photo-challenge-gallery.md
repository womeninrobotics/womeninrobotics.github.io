---
title: Photo Challenge Gallery
image: /assets/images/wir-photo-challenge.png
permalink: /photo-challenge-gallery/
layout: post
---
{% assign photos = site.data.photo_challenge | sort: "Timestamp" | reverse %}
<div class="row row-cols-1 row-cols-md-3 g-4 mb-5" data-masonry='{"percentPosition": true }' id="masonry">
{% for photo in photos %}
  {% include photo-card.html photo=photo %}
{% endfor %}
</div>
