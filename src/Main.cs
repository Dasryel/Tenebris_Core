using Godot;
using System;

namespace GameProject
{
    public partial class Main : Node2D
    {
        private DebugService _debugService;
        private MapManager _mapManager;
        private SignalBus _signalBus;
        private LevelManager _levelManager;
        private GameManager _gameManager;

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




            GD.Print("[Main] Initialized");

            // TODO figure out a better way to store map names. dict, enum, godot export, ?
            _mapManager.LoadMap("scene/map/debug.tscn");
        }


        /*
        Manual cleanup due to singletons etc
        */
        public override void _ExitTree()
        {
            this._gameManager?.Free();
            this._gameManager = null;

            this._debugService?.Free();
            this._debugService = null;

            this._mapManager?.Free();
            this._mapManager = null;

            this._levelManager?.Free();
            this._levelManager = null;

            this._signalBus?.Free();
            this._signalBus = null;

            PrintOrphanNodes();
        }
    }
}
