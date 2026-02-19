# VIM.MT.310

TUNI 2026 Game Project course group work.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setting Up Godot](#setting-up-godot)
3. [Setting Up the Repository](#setting-up-the-repository)
4. [Basic Git Usage](#basic-git-usage)
5. [Project Folder Structure](#project-folder-structure)

---

## Prerequisites

### 1. Download .NET Godot Engine

Download the **Godot Engine – .NET** (Mono) version for Windows from the official site:

> <https://godotengine.org/download/windows/>

Choose the **.NET** build – the current version used by this project is **`Godot_v4.6.1-stable_mono_win64.zip`**. Do **not** download the standard (non-.NET) build.

### 2. Download the .NET SDK

The .NET Godot build requires the .NET SDK to compile C# scripts. Download it from Microsoft:

> <https://dotnet.microsoft.com/download>

Install the latest **LTS** version. After installation, verify it works by opening a terminal and running:

```
dotnet --version
```

---

## Setting Up Godot

### Folder layout recommendation

Keep the Godot executable **outside** of the project code folder to avoid accidentally committing it or cluttering version control. A suggested layout on your machine:

```
C:\Dev\
├── Godot\                                          ← Godot executables live here
│   ├── Godot_v4.6.1-stable_mono_win64.exe
│   └── Godot_v4.6.1-stable_mono_win64_console.exe
│
└── Projects\
    └── VIM.MT.310\                 ← cloned git repository (this project)
        ├── GodotSharp\             ← extracted from the zip (see below)
        ├── src\
        ├── scene\
        ├── data\
        ├── audio\
        ├── asset\
        └── README.md
```

### Extracting GodotSharp into the project

The `.NET` Godot zip (`Godot_v4.6.1-stable_mono_win64.zip`) contains a `GodotSharp/` folder with the managed C# assemblies that the engine needs at runtime.

1. Extract the zip file somewhere temporary.
2. Copy **only** the `GodotSharp/` folder into the **root of the cloned repository** (next to this README).

```
VIM.MT.310\
└── GodotSharp\       ← copy this folder here
    ├── Api\
    ├── Tools\
    └── ...
```

> The Godot executable itself (`.exe`) should stay in its own folder (e.g. `C:\Dev\Godot\`) and **not** be placed inside the repository.

---

## Setting Up the Repository

### Clone the repository

```bash
git clone https://github.com/ahakkar/VIM.MT.310.git
cd VIM.MT.310
```

### Open the project in Godot

1. Launch `Godot_v4.6.1-stable_mono_win64.exe` from its own folder.
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
├── src/        # C# source code (.cs files)
├── scene/      # Godot scene files (.tscn / .scn)
├── data/       # JSON and other data definition files
├── audio/      # Music and sound effect files
├── asset/      # Textures, sprites, models, fonts, etc.
├── GodotSharp/ # Managed assemblies (extracted from Godot zip – not committed)
└── README.md
```

> `GodotSharp/` is already listed in `.gitignore` and will not be tracked by Git.
