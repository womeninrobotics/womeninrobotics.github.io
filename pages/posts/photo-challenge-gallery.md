---
title: Photo Challenge Gallery
image: /assets/images/wir-photo-challenge.png
permalink: /photo-challenge-gallery/
layout: post
---


{% assign photos = site.data.photo_challenge %}
<div class="row row-cols-1 row-cols-md-3 g-4 my-5">
{% for photo in photos %}
  {% include photo-card.html photo=photo %}
{% endfor %}
</div>
