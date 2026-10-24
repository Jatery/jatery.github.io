---
layout: single
title: "Now"
permalink: /now/
author_profile: true
excerpt: "Notes on what Jatery is working on and learning."
updated: "2026-10-23"
---

Last updated: {{ page.updated | date: '%-d %B %Y' }}.

{% assign updates = site.now | sort: 'order' %}
{% for item in updates %}

## {{ item.title }}

{{ item.content }}

{% endfor %}
