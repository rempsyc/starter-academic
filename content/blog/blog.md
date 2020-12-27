---
widget: portfolio

# This file represents a page section.
headless: true

# Order that this section appears on the page.
weight: 1

# Section title
title: BLOG

# Section subtitle
subtitle: Mostly about R for now

content:
  # Page type to display. E.g. project.
  page_type: project

  # Default filter index (e.g. 0 corresponds to the first `filter_button` instance below)
  filter_default: 0

  # Filter toolbar (optional).
  # Add or remove as many filters (`filter_button` instances) as you like.
  # To show all items, set `tag` to "*".
  # To filter by a specific tag, set `tag` to an existing tag name.
  # To remove toolbar, delete/comment all instances of `filter_button` below.
  filter_button:
    - name: All
      tag: '*'
    - name: Deep Learning
      tag: Deep Learning
    - name: Other
      tag: Demo
design:
  # Choose how many columns the section has. Valid values: 1 or 2.
  columns: '2'
  # Toggle between the various page layout types.
  #   1 = List
  #   2 = Compact  
  #   3 = Card
  #   5 = Showcase
  view: 3
  # For Showcase view, flip alternate rows?
  flip_alt_rows: true
---

Add any content to the body of the section here.

{{< gallery album="<album>" >}}