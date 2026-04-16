# Site Cleanup & Improvement Plan

**Repo:** `rempsyc/starter-academic`  
**Site:** https://remi-theriault.com  
**Created:** 2026-04-16  
**Branch:** `master`

---

## Overview

This plan covers security fixes, content cleanup, and organizational improvements
for the Hugo/Wowchemy academic site. Items are grouped by priority and marked with
checkboxes for tracking. Each item has context on *why* it matters and *what* to do.

---

## Stage 1: Security & Hygiene (do first)

### 1.1 Netlify CMS branch reference
- [ ] **Fix:** In `static/admin/config.yml`, the backend branch is `master`.
  This is correct since the repo still uses `master`. No action needed *unless*
  you rename to `main` (see §4.1). If you do rename, update this file too.

### 1.2 CSP headers — Report-Only mode
- [x] **Done.** Rewrote the CSP in `netlify.toml` with a complete, correct policy
  that covers all external resources the site actually uses:
  - **Scripts:** cdnjs.cloudflare.com, googletagmanager, altmetric (d1bxh8uas1mnw7.cloudfront.net),
    dimensions (badge.dimensions.ai), netlify identity, google maps
  - **Styles:** cdnjs.cloudflare.com, fonts.googleapis.com
  - **Fonts:** cdnjs.cloudflare.com, fonts.gstatic.com
  - **Images:** google maps/analytics, altmetric, dimensions, openstreetmap tiles
  - **Connections:** google analytics, GTM
  - **Frames:** google.com (maps), GTM (noscript tag)
  - Dropped `report-uri` / `report-to` (use browser DevTools Console instead)
  - Fixed syntax error from old attempt (missing `;` after `fonts.googleapis.com`)
  - **Still in Report-Only mode** — deploy and check browser console for violations.
    Once clean, rename header to `Content-Security-Policy` to enforce.

### 1.3 Google Analytics / Tag Manager IDs
- [ ] **Low risk, but note:** `GTM-NVWSFMHJ` is hardcoded in
  `layouts/partials/custom_head.html` and `custom_body.html`. GA ID `UA-162599761-3`
  is in `config/_default/params.toml`. These are public-facing by nature but worth
  knowing they're visible to anyone reading the repo.

---

## Stage 2: Content Organization

### 2.1 ~~Orphaned French directories: `post/` and `talk/`~~
- [x] **Done.** Deleted `content/fr/post/` and `content/fr/talk/` (orphaned test content).

### 2.2 ~~Empty content sections~~
- [x] **No action needed.** The index files in `blog/`, `news/`, `tutorials/` are
  required by design — actual content lives in `project-blog/`, `project-news/`,
  `project-tutorials/`, etc.

### 2.3 ~~French author profile~~
- [x] **No action needed.** French authors already exist at `content/fr/authors/`.

### 2.4 Netlify CMS — not actively used
- [ ] **Note:** CMS is not actively used (too complex). The `static/admin/`
  directory and config could be removed entirely to reduce attack surface, or
  left as-is if there's any chance of future use. Low priority.

---

## Stage 3: File Cleanup

### 3.1 Debug/temporary files (deferred — noted for later)
The following files in the repo root are debugging artifacts. Remove when ready:
- [ ] `failed to resolve output format redirects from site config.txt`
- [ ] `hugo version.txt`
- [ ] `netlify.temp.txt`

### 3.2 `netlify-temp.toml` (deferred — revisit later)
- [ ] This is a backup of `netlify.toml` with stricter CSP experiments from ~5
  years ago. Keep for now as reference; delete after the CSP review in §1.2.

### 3.3 `exampleSite/` directory
- [x] **Kept intentionally.** Used as a local reference/tutorial for Hugo/Wowchemy
  patterns in case of forgotten techniques. No action needed.
  - **Future idea:** Consider bookmarking the [Wowchemy docs](https://docs.hugoblox.com/)
    or the [upstream repo](https://github.com/wowchemy/starter-academic) instead,
    to avoid carrying ~100 extra files. But no urgency.

### 3.4 `public/` directory (local only)
- [x] **No action needed.** Confirmed: `public/` is properly gitignored and has
  0 tracked files on GitHub. It only exists locally as a Hugo build output.

---

## Stage 4: Future Improvements (later stages)

### 4.1 Rename `master` → `main`?
- [ ] **Decision needed.** GitHub's default changed to `main` in 2020. Renaming is
  cosmetic but aligns with current conventions. If you do it:
  1. Rename on GitHub: Settings → Default branch → Rename
  2. Locally: `git branch -m master main && git push -u origin main`
  3. Update `static/admin/config.yml` branch from `master` to `main`
  4. Update Netlify build settings if they reference `master`
  - **Risk:** Low, but touches deploy pipeline. Do it when you have time to verify.

### 4.2 Update Hugo + Wowchemy theme
- [ ] **Deferred.** Current state:
  - Hugo version: `0.80.0` (in `netlify.toml`), README recommends `0.110.0`
  - Wowchemy: May 2021 version (now called Hugo Blox, significantly rewritten)
  - Go version in `go.mod`: 1.15 (current is 1.22+)
  - This is a large migration. Plan separately.

### 4.3 Enforce Content-Security-Policy
- [ ] After monitoring CSP reports for a period, switch from
  `Content-Security-Policy-Report-Only` to `Content-Security-Policy` in
  `netlify.toml` to actually block malicious content injection.

### 4.4 Duplicate redirect cleanup
- [ ] `netlify.toml` has duplicate redirects — each old blog path is redirected
  twice (once with `.html` extension, once without). Both are needed for
  compatibility but could be documented with a comment for clarity.

---

## Items Explicitly Kept As-Is

These were reviewed and intentionally left unchanged:

| Item | Reason |
|------|--------|
| `../cv.pdf` in `menus.fr.toml` | Needed — doesn't work without the `../` prefix |
| `work-tracker.xlsx` files in `static/` | Intentional public downloads linked from blog |
| Old dashboard copies (`*_old.html`) | Kept for posterity |
| Multiple CV versions in `static/` | Kept for now |
| `public/` directory | Already gitignored, not on GitHub |
| `exampleSite/` directory | Kept as local Hugo/Wowchemy reference |
| Blog/news/tutorials index files | Required by design; content in `project-*` dirs |
| French author profile | Already exists at `content/fr/authors/` |
| `../cv.pdf` in French menu | Required — doesn't work without `../` prefix |
| `work-tracker*.xlsx` in `static/` | Public templates linked from blog |
| Old dashboard copies | Kept for posterity |
| Multiple CV versions | Kept for now |

---

## Quick Wins (can do right now)

1. ~~Delete `exampleSite/`~~ — kept as reference
2. ~~Delete `content/fr/post/` and `content/fr/talk/`~~ — done
3. ~~Remove empty menu items~~ — content sections are by design

---

*This file can be deleted once all items are resolved.*
