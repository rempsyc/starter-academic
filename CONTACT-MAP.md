# Contact-page maps

The English and French contact pages use their own `office-map.svg` in
`content/en/contact/` and `content/fr/contact/`. The old Meyer images are no longer
displayed. Each map links to its full-size SVG so visitors can enlarge it.
The `content.office_map` and `content.office_map_alt` fields in each `contact.md`
are rendered by `layouts/partials/widgets/contact.html` after the written contact
details and before the existing interactive campus map.

## Editing

These SVGs are the editable originals and the website assets; no image generation
or external graphics library is needed. Open them in a vector editor or edit their
XML. Keep building geometry and the route identical in both language versions.
Translate the entrance label, the small not-to-scale caption, the SVG title and
description, and the image alternative text in each `contact.md`.

- `base-map` contains the approximate building outline and corridor geometry.
- `street` positions rue Notre-Dame separately from the building. Keep a visible
  gap between its edges and the building outline.
- `green-route` contains the white route backing, green dashed path, and office
  highlight. Hide this group for a black-and-white base. Update both copies of the
  route path when changing the route.
- `labels` contains the entrance and office callouts and the schematic caption.

The footprint and connecting passage were simplified from owner-supplied annotated
map screenshots. Office geometry comes from the privately supplied corridor plan;
other occupants' names and the private original are not included. This is a
schematic visitor map, not a measured floor plan or emergency evacuation plan.
Distances and the entrance connection remain approximate.

Written directions live in `config/_default/params.toml` (English) and
`config/_default/languages.toml` (French). Keep them aligned with the maps:
Notre-Dame entrance, immediate left, door into the vestibule, second left into the
office corridor, U-1053 on the right. The route has no stairs or level changes.

## Checking changes

Run `preview.ps1`, then inspect `/contact/` and `/fr/contact/` at desktop and phone
widths. Check the street/building gap, the highlighted office and both image links.
Use `.tools/hugo/hugo.exe` for build checks. Keep SVGs self-contained and avoid
requiring Hugo features newer than the deployment-pinned Hugo 0.80.0.
