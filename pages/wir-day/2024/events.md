---
layout: post
title: Women in Robotics Day 2024 Events
image: /assets/images/wir-day-2024-celebrate.png
permalink: /wir-day/2024/events/
---

By hosting or attending an event, you can contribute to a meaningful cause that celebrates and elevates the achievements of women in robotics. Whether it's a panel discussion, a hands-on workshop, or a showcase of groundbreaking projects, these events offer a unique platform for knowledge exchange, networking, and visibility.

Find an event local to you or [create your own](/wir-day-event-registration)!

<div class="container pb-5">
    <div class="pb-5">
        {% assign events_by_year = site.data.wir_day_events | where_exp: "item", "item['date'] contains '2024'" %}
        {% assign events_by_region = events_by_year | group_by:"region" %}
        {% for region in events_by_region %}
        <div>
            <h2 class="text-primary">{{ region.name }}</h2>
            {% for event in region.items %}
            {% include event-card.html event=event %}
            {% endfor %}
        </div>
        {% endfor %}
    </div>
    <div class="massage-box alert-info">
        <strong>
            <i class="fa fa-info"></i>
            Want your event listed here?
        </strong>
        <p>We would love for you to share your events with us!! </p>
        <a href="/wir-day-event-registration" class="page-scroll btn btn-lg btn-default-filled">
            Register an event</a>
    </div>
</div>
