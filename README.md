# Ludum Dare 52
Our project for [Ludum Dare 52](https://ldjam.com/).

# Conventions
## Folder and Project structure
The project is split into separate modular features and themes in folders.

The scene file and script file names are written in `UpperCamelCase`. Other file names (including art assets) and directory names are written in `snake_case`.

Graphics, sounds and further assets are put directly besides the code in the matching folder. New subfolders are normally not needed, except when there is an extraordinary amount of new assets, that can't be organised otherwise.
*Rule of thumb: Fewer than 3 asset files? No subfolder needed.*

### Example
If the project has multiple monsters (a Zombie, a Dragon and a pink and a red elephant) we have a folder "Monster" and matching subfolders for the monster types. The project structure could look like this:

```
godot
├───monster
│   │   Monster.gd
│   ├───dragon
│   │   │   Dragon.gd
│   │   │   dragon.png
│   │   │   Dragon.tscn
│   │   ├───sounds
│   │   │       dragon_angry.ogg
│   │   │       dragon_howl.ogg
│   │   │       dragon_wing_flap.ogg
│   │   └───states
│   │           FireBreath.gd
│   │           Hovering.gd
│   │           Howl.gd
│   │           Idle.gd
│   ├───elephant
│   │   │   elephant_colorless.png
│   │   │   Elephant.gd
│   │   │   Elephant.tscn
│   │   │   elephant_horn.ogg
│   │   ├───pink_elephant
│   │   │       PinkElephant.tscn
│   │   │       PinkElephant.gd
│   │   └───red_elephant
│   │           RedElephant.tscn
│   │           RedElephant.gd
│   └───zombie
│           Zombie.gd
│           Zombie.tscn
│           zombie_death.png
│           zombie_drooling.png
│           zombie_growl.ogg
└───shared
        fire_burn.ogg
```

## Branching
New branches follow the following conventions:
- If a new feature starts development we create a new branch which starts with the prefix `dev-` and the English feature name in `kebab-case`
- **Examples:** `dev-main-menu` or `dev-dragon-monster`

## Commits
1. Have a commit message – white space or no characters at all can’t be a good description for any code change.
2. Keep a short subject line – long subjects won’t look good when executing some git commands. Limit the subject line to 50 characters.
3. Don’t end the subject line with a period – it’s unnecessary. Especially when you are trying to keep the commit title to under 50 characters.
4. Start with a capital letter – straight from the source: “this is as simple as it sounds. Begin all subject lines with a capital letter”.

Taken from [here](https://www.datree.io/resources/git-commit-message).

## Code conventions
We are following the [GDScript Guidelines from the Godot Documentation](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_styleguide.html)

And additionally the [Best Practices of GDQuest](https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/)

Please take the time to familiarize yourself with them before contributing.
