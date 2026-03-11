using Godot;
using System;

namespace GameProject
{
    public partial class Main : Control
    {
        private DebugService _debugService;
        private MapManager _mapManager;
        private SignalBus _signalBus;
        private LevelManager _levelManager;
        private GameManager _gameManager;

        private Node _currentScene;

        // Initialize program
        public override void _Ready()
        {
            this._debugService = DebugService.Instance;
            AddChild(this._debugService);

            this._signalBus = SignalBus.Instance;
            AddChild(this._signalBus);

            this._gameManager = GameManager.Instance;
            AddChild(this._gameManager);

            this._mapManager = MapManager.Instance;
            AddChild(this._mapManager);

            this._levelManager = LevelManager.Instance;
            AddChild(this._levelManager);

            SignalBus.Instance.NewGame += NewGame;

            LoadNewScene("res://scene/ui/MainMenu.tscn");
            GD.Print("[Main] Initialized");

            // TODO figure out a better way to store map names. dict, enum, godot export, ?

        }


        /*
        Manual cleanup due to singletons etc
        */
        public override void _ExitTree()
        {
            this._signalBus?.Free();
            this._signalBus = null;

            this._gameManager?.Free();
            this._gameManager = null;

            this._debugService?.Free();
            this._debugService = null;

            this._mapManager?.Free();
            this._mapManager = null;

            this._levelManager?.Free();
            this._levelManager = null;

            if (IsInstanceValid(_currentScene))
            {
                this._currentScene?.Free();
            }
            this._currentScene = null;

            PrintOrphanNodes();
        }


        public void LoadNewScene(string scenePath)
        {
            _currentScene?.QueueFree();

            PackedScene sceneFile = GD.Load<PackedScene>(scenePath);
            _currentScene = sceneFile.Instantiate();

            AddChild(_currentScene);

            if (_currentScene is MainMenu menu)
            {
                GD.Print("settin up main menu");
                menu.SetAnchorsAndOffsetsPreset(LayoutPreset.FullRect);
                menu.Position = Vector2.Zero;
                SignalBus.Instance.NewGame += NewGame;
            }
        }


        private void NewGame()
        {
            GD.Print("[Main] Starting new game");
            _currentScene?.QueueFree();
            _mapManager.LoadMap("res://scene/map/debug.tscn");
        }
    }
}
