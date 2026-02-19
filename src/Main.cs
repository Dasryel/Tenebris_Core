using Godot;
using System;

namespace GameProject
{
    public partial class Main : Node2D
    {
        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
        {
            GD.Print("Main initialized");
        }

        // Called every frame. 'delta' is the elapsed time since the previous frame.
        public override void _Process(double delta)
        {
        }
    }
}
