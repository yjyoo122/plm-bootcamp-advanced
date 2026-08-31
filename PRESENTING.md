# Facilitator guide — Advanced

For whoever is running the session. Attendees want the [README](README.md) instead.

**This is not a talk.** Fundamentals is a presentation with an exercise in it; Advanced is a build session with a presentation wrapped around it. Plan it as a workshop.

## The facilitator track is in the deck

Every screen carries two hidden fields — 91 notes and 135 scripted screens across the module:

- **`say`** — the spoken script for that screen.
- **`note`** — why the screen exists and what to watch for.

Press <kbd>S</kbd> or click **Notes**. Read the notes for a chapter *before* you teach it. In this module several of them name the exact failure the room is about to hit.

## Before the session

**Every attendee needs their own tenant with administrator access.** This is the hard prerequisite — chase it days ahead, not on the morning. The deck's own position:

> …people who follow along in their own tenant get far more from it than the ones who watch.

Attendees without a tenant aren't blocked from attending, but be honest with them that they're reading, not building.

**Warn them that roles are configured in a different product** than the workspace settings. Attendees who only have workspace-level rights will stall in chapter 4 with no obvious reason.

**Two screens is close to essential** — deck on one, tenant on the other. Say so in the invitation.

**Build it yourself, start to finish, in a clean tenant, before you teach it.** Non-negotiable for this module. You need to have personally hit the chapter 6 failure to recognise it in someone else's screen.

**There are no built-in timers in this module** (unlike the Fundamentals icebreaker). You're pacing the build segments yourself — decide your checkpoints in advance.

**Take an offline copy.** Download [index.html](https://raw.githubusercontent.com/yjyoo122/plm-bootcamp-advanced/main/index.html) and confirm it opens by double-clicking. ~9 MB.

## The three places this session goes wrong

### 1. Chapter 3 — workspace type is permanent

One of the module's three closing takeaways is *"workspace type is permanent."* An attendee who picks the wrong type has to start the workspace over. Say it **before** they create anything, and physically check the room before you move on.

### 2. Chapter 6 — the two links, and neither one warns you

The single highest-value stop in the module. Two separate things are required:

- a **workspace relationship** — says *which* workspace may be revised
- a **lifecycle mapping** — says *which states* it may be moved to

Configure one and not the other and there is **no error message**. The button is simply missing. Expect a cluster of hands here and treat it as the main event rather than an interruption — this is the mechanism the whole module is named for.

### 3. Chapter 4 / 8 — the missing button

When a transition button doesn't appear, walk the access chain in order rather than guessing:

1. Workflow transition permission
2. Role
3. Group membership
4. Workspace permissions

The deck's guidance is that a broken link in one of two chains explains nearly every "it doesn't work" in your own tenant. Teach the chain as a debugging habit — attendees will use it long after the session.

## Chapters 9–10 — the four script types

The framing that matters: they are **not four flavours of one thing**. Each answers a different question at a different moment. If attendees leave thinking scripts are interchangeable, this section didn't land.

Give chapter 10 (**On demand** — no transition, user-triggered) real weight. Per the deck, it's where most customer-specific automation ends up living, which makes it the most commercially relevant screen in the module.

## Chapter 11 — Prove it

Everything built so far doing one job: a memo released, revised, locked, carrying its history. Run it end to end on **your** screen, then have the room run it on theirs. Don't skip to the recap because time is short — this is the payoff that makes the build feel worth it.

## While presenting

- <kbd>→</kbd> reveals callouts **one at a time**. If a screen seems stuck, you're stepping through its annotations.
- **Click screenshots to enlarge.** Most screens here are configuration dialogs with small field labels — do this more often than you think you need to.
- Diagram callouts have numbered pins matching the annotation list. Point at the picture, not the text.
- <kbd>M</kbd> for the chapter menu when a question jumps ahead; <kbd>H</kbd> back to the cover.
- The shortcut card still lists <kbd>A</kbd> for basic/advanced. That toggle isn't in this module — don't offer it to the room.

## After the session

Send both links:

- Advanced: **https://yjyoo122.github.io/plm-bootcamp-advanced/**
- Fundamentals: **https://yjyoo122.github.io/plm-bootcamp-fundamentals/**

Tell them to press <kbd>P</kbd> for Explore mode — this module is far more useful as a scrollable reference than as a slideshow once they're rebuilding it alone.

Point them at chapter 12 specifically. The recap is the part they'll come back to.

---

## Session shapes

| Audience | Setup | Notes |
|---|---|---|
| Administrators, own tenant each | Full build-along | The intended shape. Budget for chapter 6 |
| Administrators, no tenants yet | Demo-along | You build, they watch. Say up front they'll need to redo it themselves |
| Partner / pre-sales technical | Full build-along | Emphasise chapters 6 and 10 — the two that come up in customer conversations |
| Self-study | Explore mode (<kbd>P</kbd>) | Works standalone; chapter 12 is the reference |
