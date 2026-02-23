using Godot;
using System;

namespace GameProject
{
    public partial class Main : Node2D
    {
        private DebugService _debugService;
        private MapManager _mapManager;
        private SignalBus _signalBus;

        // Initialize program
        public override void _Ready()
        {
            this._debugService = DebugService.Instance;
            AddChild(this._debugService);

            this._mapManager = MapManager.Instance;
            AddChild(this._mapManager);

            this._signalBus = SignalBus.Instance;
            AddChild(this._signalBus);

            GD.Print("[Main] Initialized");

            // TODO figure out a better way to store map names. dict, enum, godot export, ?
            _mapManager.LoadMap("scene/map/debug.tscn");
        }


        /*
        Manual cleanup due to singletons etc
        */
        public override void _ExitTree()
        {
            this._debugService?.Free();
            this._debugService = null;

            this._mapManager?.Free();
            this._mapManager = null;

            this._signalBus?.Free();
            this._signalBus = null;

            PrintOrphanNodes();
        }
    }
}
