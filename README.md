# 🎮 The Walking Wim

A short atmospheric horror experience built with **Godot Engine**. This repository contains a **ready-to-run Windows executable**, so you can jump straight into the game after cloning — no Godot setup required.

---

## 🧟 About the Game

This is a small horror project to get me familiar with 3D-game development, state machines and AI navigation agents.  
The aim of the game is to collect 10 EC's in the map. You lose the game if the monster catches you.

---

## 🚀 Getting Started

### Option 1: Play the Game (No Godot Required)

#### Requirements

* **Windows OS**
* No additional dependencies
* Godot installation **not required** to play

#### Run the Game

1. Clone the repository:

   ```bash
   git clone https://github.com/vikki200625/walking-wim-game.git
   ```

2. Navigate into the project folder:

   ```bash
   cd walking-wim-game
   ```

3. Launch the game by running, or simply click the exe file in the file explorer:

   ```bash
   .\The Walking Wim.exe
   ```

---

### Option 2: Open in Godot Editor

#### Requirements

* **Godot Engine 4.x** (4.0 or newer recommended)
* Download from: https://godotengine.org/download

#### Open the Project

1. Clone the repository:

   ```bash
   git clone https://github.com/vikki200625/walking-wim-game.git
   cd walking-wim-game
   ```

2. Open Godot Engine

3. Click **Import** and navigate to the project folder, or drag the folder into Godot

4. Select the `project.godot` file and click **Import**

5. The project will open in the Godot Editor

#### Run from Editor

1. Press **F5** or click the **Play** button (▶) in the top-right corner

2. The game will launch in a new window

#### Export the Game

1. Go to **Project → Export**

2. Select your target platform (Windows, Linux, macOS, Web)

3. Click **Export Project**

4. Choose a save location and click **Export**

---

## 🎮 Controls

| Action       | Key     |
| ------------ | ------- |
| Move         | W A S D |
| Run          | Shift   |
| Look Around  | Mouse   |
| Quit         | ESC     |

---

## 📁 Project Structure

```
walking-wim-game/
├── Assets/              # 3D models, textures, materials
│   ├── Chairs/         # Chair models
│   ├── Doors/          # Door models
│   ├── Lockers/        # Locker models
│   ├── Tables/         # Table models
│   ├── Textures/       # Floor and wall textures
│   └── pc/             # Computer models
├── CollectionPoints/    # Collectible items and scripts
├── Fonts/              # Custom fonts
├── Map/                # Level design
├── Monster/            # Zombie model and AI scripts
├── Player/             # Player model and movement scripts
├── Sound/              # Music, sound effects, zombie moans
├── States/             # AI state machine scripts
├── UI/                 # Menus, HUD, game over screen
├── project.godot       # Godot project file
├── main.tscn           # Main game scene
├── main.gd             # Main game script
└── README.md           # This file
```

---

## 🛠 Built With

* **Godot Engine 4.x** (GDScript)
* Imported assets and music
* AI State Machine for monster behavior
* NavigationAgent3D for enemy pathfinding

---

## ⚠️ Disclaimer

* This game may contain **flashing lights**, **loud sounds**, or **intense scenes**.
* Play with headphones for the best experience.
* I do not own the 3D models, textures, music or sound effects used in the game. All assets are the property of their respected creator and are used for educational purposes only.
* This project is not intended for commercial use.

---

## 📜 License

This project is shared for **educational and personal use**.

* You may **play and explore** the project freely
* Do not redistribute or sell the game or its assets without permission

(Add a proper license here if you want it to be open-source.)

---

## 💬 Feedback

Found a bug? Have an idea? Feel free to open an **Issue** or start a discussion.

Enjoy the horror 😈
