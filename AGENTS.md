# Repository instructions for coding agents

## Documentation and tools

Keep human-readable maintenance guides at the repository root and link them from `README.md`. Keep executable maintenance tools in `scripts/`.

## Portfolio images

Before adding or replacing featured images for News, Blog, Media, or R tutorials, read and follow [PORTFOLIO-IMAGES.md](PORTFOLIO-IMAGES.md).

- Run `scripts/optimize_portfolio_images.py` with Python and Pillow after changing portfolio images.
- Include the updated `data/portfolio_images.toml` and generated `static/media/portfolio/*.webp` files in the change. Do not edit the generated manifest by hand.
- Preserve original images beside their content pages. English and French copies with identical bytes share generated thumbnails.
- Verify both language pages use the generated thumbnails and check their appearance, crop, and filter buttons. Report thumbnail sizes and any verification limits.

## Site preview and validation

Use `preview.ps1` for live previews. For build checks, use the project-local `.tools/hugo/hugo.exe` (Hugo Extended 0.110.0) when available. The globally installed Hugo may be incompatible with this legacy theme.

Preserve compatibility with the deployment-pinned Hugo 0.80.0. Keep Hugo, theme, and dependency upgrades separate from routine content changes.
