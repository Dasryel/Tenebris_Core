using Godot;
using System;

namespace GameProject
{
    public partial class Main : Node2D
    {
        private MapManager _mapManager;
        private SignalBus _signalBus;

        // Initialize program
        public override void _Ready()
        {
            this._signalBus = SignalBus.Instance;
            AddChild(this._signalBus);

            this._mapManager = MapManager.Instance;
            AddChild(this._mapManager);

            GD.Print("Main initialized");
        }

    }
}
