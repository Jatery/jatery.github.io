# Design — Jatery

This is the small, project-specific design contract for the Jekyll site. It is intentionally kept close to the files that implement it: content belongs in Markdown and YAML, structure in layouts and includes, and presentation in Sass.

## Purpose

- Audience: people who may want to work with, hire, or simply understand Jatery.
- Job: give a clear first impression of one person across computing, music, and making.
- Tone: plain, personal, observant. Never a résumé template or a polished product landing page.

## Page shape

- Homepage: Long Document spine with a compact portrait opening, followed by About → Selected → Contact in one reading flow.
- Now: a looser text page using the same type, colour, and masthead.
- Posts: Minimal Mistakes’ article structure under the same surface styles.
- Navigation: N1 minimal wordmark navigation; JATERY at the start and only the three real destinations at the end.
- Footer: Ft4 quiet colophon; one compact line from Minimal Mistakes, not a sitemap.

## Surface and type

- Near-white warm paper, dark warm ink, quiet rules, and one muted green accent.
- IBM Plex Sans carries headings, prose, metadata, and navigation.
- Instrument Serif appears only in the JATERY wordmark. It is the site’s one small typographic aside.
- Body copy stays between 45 and 68 characters wide with a comfortable line height.
- Headings are modest and upright. No giant display type, italics-for-drama, or section eyebrows.

## Layout and rhythm

- The content column is at most 64rem wide; prose is narrower.
- The hero is content-height, never viewport-height. The supplied portrait remains rectangular and smaller than the copy column.
- About is one column. Personality details live inside the prose rather than in callout cards.
- Selected things are consistent ruled rows. Only real media is shown; an absent image leaves no placeholder.
- Contact is a short closing sentence plus plain links.
- Use the spacing tokens from `_sass/_jatery-tokens.scss`; do not introduce one-off layout values without adding a named token.

## Interaction

- The page is still. There are no entrance animations or moving hover effects.
- Links change colour or underline only.
- Focus is immediate and visible; touch targets are at least 44px.
- Clickable labels remain on one line and containers wrap instead.

## Shared rules

Every page shares the masthead, paper colour, typography, link treatment, focus ring, and square image geometry. Pages may differ in prose measure and whether they include meaningful media.

Avoid cards, shadows, tinted section panels, double rules, decorative arrows, numbered section labels, equal feature grids, gradients, and invented visual filler.

## Canonical implementation

`_sass/_jatery-tokens.scss` is the canonical token source. `_sass/_jatery-home.scss` implements the site-specific layer on top of Minimal Mistakes; Jekyll compiles both into one `main.css`.
