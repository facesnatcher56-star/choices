# Please Do Not Feed the Moon

An offline surreal branching story built in Godot. You are Alex Vale. You wake inside a cake at your own funeral, surrounded by copies of yourself. Above the Hotel Nobody, the moon is starting to hatch.

## Play

Open `project.godot` in Godot and press **F5**. New games start directly in the new story. No accounts, network access, or downloads are required.

- Choose short actions with the mouse or **1–9**. Buttons do not disclose consequences or show score changes.
- **Space / Enter** continues narrative beats. Choices appear after the scene has been read.
- **Esc / Menu** opens the story history, people, and save controls.
- Automatic checkpoints follow choices. Manual saves and **New story** are available in the menu.
- **F3** opens the developer inspector, which contains spoilers.

The story has 27 scenes, 63 choices, and six endings. Routes branch through the hotel's kitchen, a tooth-train, an upside-down aquarium, a trial of gravity, and the nursery inside the moon. Earlier decisions affect later scenes and the ending: the key, your name, your shadow, Mox, and the people or days you bring out with you.

The original factory story and the subsequent auction add-on are not part of new games. Their code remains for legacy snapshots and regression work. New-game routing bypasses their NPC turns, finances, schedules, and encounters. The old scenario can be constructed explicitly with `World.new(seed, true)` for development. The application now uses the user-data folder named **Please Do Not Feed the Moon**; earlier saves remain in the old **One Bad Week** folder.

## Source

- `scripts/moon_data.gd`: the complete authored scene graph.
- `scripts/moon_story.gd`: new cast, progression, remembered choices, and conditional outcomes.
- `scripts/world.gd`: story history and validated local snapshots.
- `scripts/director.gd`: routing and choice validation.
- `scripts/story_view.gd`: reading view, simple choices, menu, and saves.

## Verification

Run with Godot:

```text
godot --headless --path . --script tests/moon_test.gd
```

The new suite checks every authored choice, all scene destinations, 150 complete playthroughs, all six endings, mid-story saves, rejected choices, conditional key outcomes, and actual interface buttons. Older test suites target the retired factory scenario and are not the acceptance suite for the new story.
