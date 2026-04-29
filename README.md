# VIM.MT.310

TUNI 2026 Game Project course group work.

---

Tenebris Core is a 2D Metroidvania action-platformer set in a mysterious atmospheric world. Players explore  2 completely different zones, battle enemies, master movement abilities like the double jump, and collect scattered moon pieces to restore the portal at the heart of the game. With moody visuals and music, hidden secrets, and an alternate ending, Tenebris Core offers a compact but immersive adventure.

The game was created by Team SANDA as part of the Game Project 2026 course at Tampere University, Finland.

## Credits

FONT
- Scifibit font - Andreas Nylin - https://www.dafont.com/sci-fied-bitmap.font

MUSIC
- Dark Horse 2 - Centurion_of_war - https://opengameart.org/users/centurionofwar
- Robotic City V2 - section31 - https://opengameart.org/content/robotic-city-v2
- Sky Fish - Holizna - https://holiznaroyaltyfree.bandcamp.com/track/sky-fish

GAME SOUNDS
- hup - maxmakessounds - https://freesound.org/people/maxmakessounds/sounds/353542/

SPRITES
- Super Grotto Escape - ansimuz - https://ansimuz.itch.io/super-grotto-escape-pack

Special thanks to:
- Brackeys
- Coco Code
- ChatGPT, Claude
---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setting Up Godot](#setting-up-godot)
3. [Setting Up the Repository](#setting-up-the-repository)
4. [Basic Git Usage](#basic-git-usage)
5. [Project Folder Structure](#project-folder-structure)
6. [Git commit-prefixes](#git-commit-prefixes)

---

## Prerequisites

### 1. Download Godot Engine

Download the **Godot Engine ** for Windows from the official site:

> <https://godotengine.org/download/windows/>

---

## Setting Up Godot

### Folder layout recommendation

Keep the Godot executable **outside** of the project code folder to avoid accidentally committing it or cluttering version control. A suggested layout on your machine:

```
C:\Dev\
├── Godot\
│   └── Godot 4.6\                  ← Godot executables live here
│       ├── Godot_v4.6.1-stable_win64.exe
│       └── Godot_v4.6.1-stable_win64_console.exe
│
└── Projects\
    └── VIM.MT.310\                 ← cloned git repository (this project)
        ├── src\
        ├── scene\
        ├── data\
        ├── audio\
        ├── asset\
        └── README.md
```

### Clone the repository

```bash
git clone https://github.com/ahakkar/VIM.MT.310.git
cd VIM.MT.310
```

### Open the project in Godot

1. Launch `Godot_v4.6.1-stable_win64.exe` from its own folder.
2. In the **Project Manager**, click **Import** and navigate to the cloned `VIM.MT.310` folder.
3. Select the `project.godot` file and click **Import & Edit**.

---

## Basic Git Usage

Below are the everyday Git commands you will need.

### Check current status

```bash
git status
```

### Stage changes

```bash
# Stage a specific file
git add path/to/file

# Stage all changed files
git add .
```

### Commit staged changes

```bash
git commit -m "Short description of what you changed"
```

### Push changes to GitHub

```bash
git push
```

### Pull latest changes from GitHub

```bash
git pull
```

### Full day-to-day workflow example

```bash
git pull                        # always pull before you start working
# ... make your changes ...
git add .                       # stage everything (or specify files)
git commit -m "Add player movement script"
git push                        # share your work with the team
```

---

## Project Folder Structure

```
VIM.MT.310/
├── src/        # Source code (.cs files)
├── scene/      # Godot scene files (.tscn / .scn)
├── data/       # JSON and other data definition files
├── audio/      # Music and sound effect files
├── asset/      # Textures, sprites, models, fonts, etc.
└── README.md
```
