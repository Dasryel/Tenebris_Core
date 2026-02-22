using Godot;
using System;

namespace GameProject
{
    public partial class SignalBus : Node2D
    {
        private static readonly SignalBus _instance = new();
        public static SignalBus Instance => _instance;

        public override void _Ready()
        {
            this.Name = "SignalBus";
        }

        // Called every frame. 'delta' is the elapsed time since the previous frame.
        public override void _Process(double delta)
        {
        }
    }
}
