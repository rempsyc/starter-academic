# Portfolio image optimization

Applies to News, Blog, Media, and R tutorials in English and French. Reports,
slides, publication images, profile images, and their originals are unchanged.

## Adding or replacing a photo

1. Add the featured image beside its page as usual. Existing English/French
   copies can stay in place; identical bytes share one set of WebP thumbnails.
2. Run `python scripts/optimize_portfolio_images.py` with Python and Pillow.
3. Include the generated `data/portfolio_images.toml` and
   `static/media/portfolio/*.webp` files with the change.
4. Preview both languages and check the picture, crop, and filter buttons.

The script never overwrites source pictures. It generates at most two widths
(320 and 550 pixels, capped at the source width). Tutorial images and PNG news
artwork use lossless WebP to protect charts and lettering; other images use
quality 88. The source and encoded-content hashes keep shared URLs stable until
the image or encoding changes. The script removes only obsolete generated WebP
files inside its dedicated output directory, never originals.

No encoder is needed on Netlify: these WebP files are committed outputs. Hugo
0.80.0 still generates JPEG/PNG fallbacks. If a new photo has not been processed,
the templates automatically use those fallbacks instead of a missing WebP URL.
No Hugo, theme, module, or dependency versions were changed.

## Preserving appearance and URLs

The local card/showcase partials preserve the pinned theme's image selection,
links, CSS classes, and displayed dimensions. The old Hugo-generated `src` URL
is still published; browsers select optimized alternatives through `srcset` and
`picture`. Small sources are no longer enlarged in the delivered alternatives,
but retain their previous displayed size. Originals also remain available for
detail pages, downloads, and social metadata.

The theme's broad `*featured*` selector is intentionally unchanged. For example,
English Busara currently selects `featured - Copy.jpg`. Removing that file or
switching to `featured.jpg` would change the visible picture. For new pages,
keep only one filename containing `featured` to avoid ambiguous selection.

## Local theme overrides

- `layouts/partials/portfolio_image.html`: responsive sources, dimensions,
  shared WebP lookup, eager loading of the first row, lazy loading below it.
- `layouts/partials/portfolio_li_card.html` and `portfolio_li_showcase.html`:
  copies of the pinned templates that call the image partial. The card sizes
  account for the theme's 1290-pixel desktop container and 1/2/3-column grid.
- `assets/js/wowchemy.js`: copy of Wowchemy commit `81ba17522966`, with only
  portfolio initialization changed. Images with intrinsic dimensions can be
  laid out immediately instead of waiting for every lazy image to load. Other
  widgets retain the original imagesLoaded behavior.
- `layouts/partials/functions/is_portfolio_menu.html`: identifies these menu
  pages from the content folder, including French slugs. Their footer skips
  unused Google Maps and citation-badge scripts; other pages retain them.

Both the deployment-pinned Hugo 0.80.0 and local Hugo 0.110.0 must remain
compatible. Hugo 0.80.0 already reports a module compatibility warning before
these changes; it builds the existing site and the optimized site successfully.
