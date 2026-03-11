using Godot;
using System;

namespace GameProject
{
    public partial class Main : Control
    {
        [Export] private CanvasLayer _uiLayer;
        [Export] private PackedScene _playerUIScene;

        [Export] private DebugService _debugService;
        [Export] private MapManager _mapManager;
        [Export] private SignalBus _signalBus;
        [Export] private LevelManager _levelManager;
        [Export] private GameManager _gameManager;
        [Export] private InventoryManager _inventoryManager;

        private Node _currentScene;
        [Export] private Control _activeUI;

        // Initialize program
        public override void _Ready()
        {
            LoadNewScene("res://scene/ui/MainMenu.tscn");
            GD.Print("[Main] Initialized");

            // TODO figure out a better way to store map names. dict, enum, godot export, ?

        }


        /*
        Manual cleanup due to singletons etc
        */
        public override void _ExitTree()
        {
            GD.Print("[Main] closing the game");

            //PrintOrphanNodes();
        }

        public override void _Notification(int what)
        {
            if (what == NotificationPredelete)
            {
                GD.Print($"[Main] is being deleted");
            }
        }


        public void LoadNewScene(string scenePath)
        {
            _currentScene?.QueueFree();

            PackedScene sceneFile = GD.Load<PackedScene>(scenePath);
            _currentScene = sceneFile.Instantiate();

            AddChild(_currentScene);

            if (_currentScene is MainMenu menu)
            {
                GD.Print("[Main] Setting up main menu");
                menu.SetAnchorsAndOffsetsPreset(LayoutPreset.FullRect);
                menu.Position = Vector2.Zero;
                SignalBus.Instance.NewGame += NewGame;
            }
        }


        private void NewGame()
        {
            SignalBus.Instance.NewGame -= NewGame;
            GD.Print("[Main] Starting new game");
            _currentScene?.QueueFree();
            _mapManager.LoadMap("res://scene/map/mvp.tscn");
            LoadPlayerUI();
        }


        private void LoadPlayerUI()
        {
            if (IsInstanceValid(_activeUI))
            {
                _activeUI.QueueFree();
                _activeUI = null;
            }

            _activeUI = _playerUIScene.Instantiate<Control>();
            _uiLayer.AddChild(_activeUI);
            GD.Print("[Main] Player UI Loaded");
        }
    }
}
