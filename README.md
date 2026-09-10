# One Bad Week

An entirely offline Godot text-game prototype set in Briar Glen. Start as Daniel Mercer, a night supervisor who finds an injured coworker beside a bypassed machine guard. Nobody knows who installed the wire. The simulation does not quietly invent an answer.

## Play

Open `project.godot` in Godot and press **F5**. The main scene is already configured. Tested with **Godot 4.7 stable**, using the compatibility renderer; no add-ons, network, backend, API keys, or asset downloads are required. The supplied machine has 4.7 stable and 4.8-dev2 available, not the brief's requested 4.7.2 executable. The code uses standard Godot 4 APIs.

- Click an approach or press **1–4**.
- **Other approaches / O** cycles through the available options without advancing time. **Tab** moves keyboard focus normally.
- **Menu / Esc** opens character stats, people, knowledge, story history, and save controls. The reading screen shows only a compact context line, the story, and choices.
- **People**, inside Menu, shows the cast and your character's memories of them.
- **What I know**, inside Menu, shows personal knowledge, sources, confidence, and private information belonging to the current character.
- **Story so far**, inside Menu, preserves the complete narrated story, including choices and previous perspectives.
- **F3** opens the spoiler-filled developer inspector. Choose any resident and one of six views. **Esc** closes it.
- **Save story** in Menu writes a manual snapshot. **Resume checkpoint** loads the latest automatic checkpoint, falling back to the manual save if needed. **Load manual save** is also in Menu.
- **New story** asks before replacing the automatic checkpoint and retains the manual save.

The interface uses a centered reading column with larger serif story text and understated text choices. The sidebar, art banner, persistent statistics, and routine save messages are removed from the reading view. The first screen and four main choices fit at 1280×900. Longer scenes scroll. Choice duration and reasons are available on hover. Warnings appear before optional dangerous actions.

## What is implemented

- A branching opening: emergency response, physical evidence, employer pressure, police statements, and home life.
- Thirty named residents; nine central characters have authored roles. Background residents have modest daily routines rather than bespoke storylines.
- Canonical locations, characters, possessions, objects, finances, relationships with eight dimensions, event records, knowledge provenance, layered memories, beliefs, and pending intentions.
- Ongoing town choices: visits, work, family, evidence, debt, recovery, conversations, and rest. NPCs can alter records, report witnessed pressure, pursue a private job application, relay an allegation, and repay a documented loan.
- Nine conditional encounters about school costs, promises, a job interview, conflicting statements, employer pressure, medical bills, a loan, collective action, and neighborly help.
- Delayed outcomes: evidence can produce a safety investigation and plant suspension; employer resentment can remove Daniel from the rota; allegations reach Nate through Cole; promises return later.
- Eight warned hazard categories: machinery, fatigued driving, fire, electricity, falls, chemical exposure, structural collapse, and neglected injury. Exposure is optional and death is probabilistic. Death selects a living connected successor, preserving the same town and each person's own knowledge.
- Automatic and manual human-readable JSON snapshots, temporary-file writes followed by rename, schema checks, and preserved random state.
- Original procedural factory artwork is retained as an optional asset, but is not displayed in the streamlined reading view. No image generation or external art dependencies.

This is a playable **offline foundation**, not an unlimited story generator or a completed 3–5 hour campaign. Storylets are authored and conditional; ordinary activities can repeat after the nine encounters are exhausted. Time can continue beyond the first week. The architecture is designed for adding more authored situations, conditions, and local simulation rules.

## Save files

Godot's user-data folder contains `autosave.json` and `world.json`. On a normal Windows run, this is `%APPDATA%\Godot\app_userdata\One Bad Week\`. Each snapshot contains the entire state, including events and story history, so related collections cannot get out of sync across separate files. No credentials or network settings exist.

Loading does not reroll pending outcomes: the 64-bit random state is serialized as a string, avoiding JSON number precision loss. Rejected actions do not advance time. A failed load leaves the running story intact. Saves are local JSON, not tamper-resistant or encrypted. Broad memory searches are still linear, appropriate for this prototype rather than a hundred-thousand-event campaign.

## Source layout

- `scripts/seed.gd`: initial world and cast.
- `scripts/world.gd`: records, character-specific retrieval, time, relationships, persistence and save validation.
- `scripts/director.gd`: available actions, precondition validation, action resolution, NPC decisions, hazards and successor selection.
- `scripts/encounters.gd`: conditional authored situations and their structured effects.
- `scripts/story_view.gd`: one playable scene, choices, information panels and inspector.
- `scripts/town_art.gd`: the original factory silhouette.

The offline pipeline is **available action → validate → apply action → NPC turns → conditional scene → narration**. Only exposed action IDs can commit. Claims and personal interpretations are marked as uncertain rather than treated as proven world facts. Private NPC events do not become player knowledge unless there is a disclosure or public notice.

## Verification

Run with your Godot executable:

```text
godot --headless --path . --script tests/simulation_test.gd
godot --headless --path . --script tests/ui_test.gd
```

Simulation tests cover browsing without time advance, rejection without mutation, private knowledge, hearsay, relationship changes, delayed investigation, NPC agendas, memory archiving, JSON round trips, random-state continuity, corruption rejection, succession, and five 160-action runs. UI tests exercise actual button signals, all resident/inspector combinations, checkpoints, and restart. Test snapshots go under `tests/`, never over a player's saves.

To capture the initial screen for layout verification:

```text
godot --path . -- --capture
```

That writes `tests/screen.png` and exits. Tests, captures, and the locally extracted verification engine are ignored by version control.
