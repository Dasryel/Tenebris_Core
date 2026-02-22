using Godot;
using System;

namespace GameProject
{
    public partial class Main : Node2D
    {
        private DebugOverlay _debugOverlay;
        private MapManager _mapManager;
        private SignalBus _signalBus;

        // Initialize program
        public override void _Ready()
        {
            this._debugOverlay = DebugOverlay.Instance;
            AddChild(this._debugOverlay);

            this._mapManager = MapManager.Instance;
            AddChild(this._mapManager);

            this._signalBus = SignalBus.Instance;
            AddChild(this._signalBus);

            GD.Print("[Main] Initialized");

            _mapManager.LoadMap("scene/map/world/debug.tscn");
        }


        /*
        Manual cleanup due to singletons etc
        */
        public override void _ExitTree()
        {
            this._debugOverlay?.Free();
            this._debugOverlay = null;

            this._mapManager?.Free();
            this._mapManager = null;

            this._signalBus?.Free();
            this._signalBus = null;

            PrintOrphanNodes();
        }
    }
}
