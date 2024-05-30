---
layout: post
title: Project Connect
image: /assets/images/project-connect.jpg
permalink: /project-connect/

infos:
  - title: "Local chapters"
    url: "/chapters/"
    image: "/assets/images/local-chapters-2.png"
    description: "We thrive through our vibrant local chapters. These groups convene regularly, offering a supportive space for women to network, exchange knowledge, and bolster each other's careers. Joining a local chapter allows women to form meaningful connections within their region, benefiting from peer support and collaborative guidance."
  - title: "Virtual Events and Workshops"
    url: "/events/"
    image: "/assets/images/virtual-events.png"
    description: "We host a variety of virtual events and workshops. These include webinars, skill-building sessions, and online networking opportunities, enabling women to expand their knowledge, share insights, and connect with peers worldwide from the convenience of their homes."
  - title: "Global Online Community"
    url: "/signup/"
    image: "/assets/images/global-community.png"
    description: "Our global online community is a cornerstone of Women in Robotics. This community allows women from around the globe to interact, share their journeys, and access a rich repository of resources and information. Whether seeking advice, mentorship, or professional development, our online community provides invaluable support to women in robotics."
---

## What is it

Project Connect is our initiative to connect women who are working on robotics or those who aspire to.  The Women in Robotics network allows you access to opportunities you might be able to find on your own.  We provide an active slack community, local chapters, and virtual events.  These activities are designed to broaden both your knowledge of robotics, and your network.  Networking has been shown as one of the most effective methods for accelerating the pace of your career development and providing you with more opportunities to succeed.

All Women in Robotics activities are conducted under a strict [Code of Conduct](/code-of-conduct/) to ensure the safety and security of attendees.

<div class="row">
{% for info in page.infos %}
{% include info-card.html info=info %}
{% endfor %}
</div>
