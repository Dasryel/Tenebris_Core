using Godot;
using System;

namespace GameProject
{
    public partial class MapManager : Node2D
    {
        private static readonly MapManager _instance = new();
        public static MapManager Instance => _instance;

        public override void _Ready()
        {
            this.Name = "MapManager";
        }

    }
}
