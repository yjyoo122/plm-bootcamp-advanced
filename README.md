# PLM Bootcamp — Advanced

A hands-on build module for Autodesk **Fusion Manage** (PLM). You don't watch this one — you build alongside it.

Over twelve chapters you construct a revision-controlled **Meeting Memos** workspace and wire up the mechanism that drives it: workspace relationships, lifecycle mappings, a workflow, precondition filters, and four kinds of script.

## ▶ Open the training

### **https://yjyoo122.github.io/plm-bootcamp-advanced/**

No install, no login, no download. Click and it runs in your browser.

> **Do [Fundamentals](https://github.com/yjyoo122/plm-bootcamp-fundamentals) first.** This module assumes you already know what a workspace is and how a change process moves. → [Open Fundamentals](https://yjyoo122.github.io/plm-bootcamp-fundamentals/)

## Before you start — you need a tenant

This is a build-along. The deck says it plainly:

> …people who follow along in their own tenant get far more from it than the ones who watch.

To get the value, you need **your own Fusion Manage tenant with administrator access**. Several steps configure tenant-level objects (roles, for instance, live alongside PLM Settings rather than inside it), so workspace-level permissions alone aren't enough.

You can still read it without a tenant — it works fine as reference material — but you won't build anything.

## Quick start

1. Open the link above.
2. Press <kbd>F</kbd> for fullscreen.
3. Press <kbd>→</kbd> or <kbd>space</kbd> to advance.
4. Press <kbd>?</kbd> any time for the shortcut list.

Reading rather than being presented to? Press <kbd>P</kbd> for **Explore** mode — the whole module becomes one scrollable page with a table of contents. That's the better mode when you're working in a second window and need to scroll back to a step.

## Requirements

| | |
|---|---|
| **Browser** | Any current Chrome, Edge, Firefox, or Safari |
| **Install** | None |
| **Account / login** | None to view the deck |
| **To build along** | Fusion Manage tenant with admin access |
| **Internet** | Only to load the page the first time |
| **Screen** | 16:9 projector or laptop. A second screen helps — deck on one, tenant on the other |

Single self-contained HTML file, 8.9 MiB. All 120 images are embedded and nothing is fetched from a CDN, so once loaded it keeps working with the network off.

## Running it offline

1. Download **[index.html](https://raw.githubusercontent.com/yjyoo122/plm-bootcamp-advanced/main/index.html)** (right-click → Save link as…, ~9 MB)
2. Double-click it. Opens in your browser and runs identically — no web server needed.

---

## Navigating

### Toolbar

| Control | What it does |
|---|---|
| ☰ | Chapter menu |
| ⌂ | Back to the cover |
| ← → | Back / forward |
| **Notes** | Presenter notes for the current screen |
| **Present / Explore** | Slide mode vs. scrollable-page mode |
| ? | Shortcut list |
| ⛶ | Fullscreen |

### Keyboard shortcuts

| Key | Action |
|---|---|
| <kbd>→</kbd> / <kbd>space</kbd> / <kbd>PageDown</kbd> | Next — also reveals callouts one at a time |
| <kbd>←</kbd> / <kbd>PageUp</kbd> | Back |
| <kbd>S</kbd> | Presenter notes |
| <kbd>P</kbd> | Present / Explore mode |
| <kbd>F</kbd> | Fullscreen |
| <kbd>H</kbd> | Jump to cover |
| <kbd>M</kbd> | Chapter menu |
| <kbd>Esc</kbd> | Close menu, notes, or an enlarged image |

Click any screenshot to enlarge it — worth doing often here, since most screens are configuration dialogs. <kbd>Esc</kbd> closes.

> **Two notes.** <kbd>→</kbd> steps through a screen's callouts before moving on; if it seems stuck, it isn't. And the built-in shortcut card still lists <kbd>A</kbd> for basic/advanced — that toggle doesn't exist in this module. Ignore it.

---

## What you build

| # | Chapter | What it covers |
|---|---|---|
| 1 | **Cover** | Title and host |
| 2 | **The idea** | Two workspace types, one mechanism. Everything after this is scaffolding for the moment they connect |
| 3 | **Meeting Memos** | The revision-controlled workspace — the thing under control. Holds the memo and every revision, and never moves itself |
| 4 | **Access** | Roles carry permissions, groups carry people — and the two are configured in different products |
| 5 | **Memo Revision** | The revisioning workspace — the thing that moves. Carries the workflow; its Managed Items tab drives revisions on the other workspace |
| 6 | **The two links** | A workspace relationship says *which* workspace may be revised; a lifecycle mapping says *which states* it may move to. Both required, **neither one warns you** |
| 7 | **Workflow** | States are places, transitions are moves. Two checkboxes in the state panel carry the whole behaviour |
| 8 | **Preconditions** | A role picks the population; a precondition filter narrows it to the responsible person on that individual record — with no code |
| 9 | **Scripts** | Four script types, each answering a different question at a different moment. Not four flavours of one thing |
| 10 | **On demand** | The script type with no transition — the user runs it. Where most customer-specific automation ends up living |
| 11 | **Prove it** | Everything built so far doing one job: a memo released, revised, locked, carrying its history |
| 12 | **Recap** | What you built, what to check first when it doesn't work, and the three things worth writing down |

Chapter 6 is where most builds break, and it fails silently. Chapter 12 gives you the debugging chain.

## Who this is for

- **Administrators and implementers** — the core audience. Build it in your own tenant.
- **Partners / pre-sales technical** — build it once so you can answer configuration questions without hedging.
- **Facilitators** — read **[PRESENTING.md](PRESENTING.md)** first. This session needs more prep than Fundamentals does.
- **End users** — you want [Fundamentals](https://yjyoo122.github.io/plm-bootcamp-fundamentals/) instead.

## The bootcamp series

| Module | Audience | Link |
|---|---|---|
| **Fundamentals** | Everyone. Start here | [Open](https://yjyoo122.github.io/plm-bootcamp-fundamentals/) · [Repo](https://github.com/yjyoo122/plm-bootcamp-fundamentals) |
| **Advanced** *(this one)* | Administrators, implementers | [Open](https://yjyoo122.github.io/plm-bootcamp-advanced/) |

## Sharing it

The link is public — anyone with it can open the module, no account needed. Because a browser must receive the whole file to display it, anyone viewing can also save a copy. Treat the content as shareable.

## Maintaining this module

<details>
<summary>For whoever owns the content</summary>

All content lives in a single `DECK` array inside `index.html`; structure, styling, and behaviour are separate from it.

- **To edit content** — change `DECK` only.
- **To translate** — translate `DECK` only. Japanese and Korean font fallbacks are already in the font stacks.
- **Facilitator track** — `note` is the guidance, `say` is the spoken script. This module has 91 notes and 135 scripted screens.
- **Images** are base64 data URIs in the image registry, keyed by short name.

### Publishing a new version

In this repo folder (`C:\Users\yooy\plm-bootcamp-advanced`):

- **Double-click `Publish deck.bat`** — publishes `PLM Technical Bootcamp - Advanced.html` from the OneDrive bootcamp folder
- **Drag any `.html` onto `Publish deck.bat`** — publishes that file instead

It copies the file, re-applies the browser-tab title, commits, and pushes. Pages rebuilds in about a minute.

The script is **pinned to the Advanced filename on purpose** — the Fundamentals deck lives in the same source folder, and a "newest file wins" rule would publish the wrong deck.

Manually, if you prefer git:

```bash
cd plm-bootcamp-advanced
# replace index.html with the new build
git commit -am "Update advanced module"
git push
```

Or with no tools: repo page → `index.html` → pencil icon → upload. Works while the file stays under **25 MiB** (GitHub's browser upload limit); it is currently 8.9 MiB.

### Things to know

- **Browsers cache the page for 10 minutes.** Hard-reload with <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd> if you still see the old version.
- **Every revision stores a full ~9 MB copy.** GitHub recommends staying under 1 GB, so roughly 110 updates of runway. The publish script warns you as you approach it.
- **Don't rename the repository.** It changes the Pages URL and breaks every link already shared — `github.io` paths do not redirect.
- The cover heading reads **"Build the mechanism"**, which is deliberate; only the browser-tab title is normalised to "PLM Bootcamp - Advanced". To change the cover, edit the deck source.

</details>

---

*Hosted by Yeon Jong (YJ) Yoo · Autodesk Fusion Manage*
