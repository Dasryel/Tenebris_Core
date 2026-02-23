using Godot;
using System;

namespace GameProject
{
    public partial class MapManager : Node2D
    {
        private static readonly MapManager _instance = new();
        public static MapManager Instance => _instance;

        private static Node _currentMapInstance;

        public override void _Ready()
        {
            this.Name = "MapManager";
            GD.Print("[MapManager] instance created");
        }


        public bool LoadMap(string scenePath)
        {
            if (!FileAccess.FileExists(scenePath))
            {
                GD.PrintErr($"[MapManager] Map path not found: {scenePath}");
                return false;
            }

            PackedScene mapScene = ResourceLoader.Load<PackedScene>(scenePath);
            _currentMapInstance = mapScene.Instantiate();

            AddChild(_currentMapInstance);
            GD.Print($"[MapManager] Loaded map: {scenePath}");

            return true;
        }

        public static string GetCurrentMapName()
        {
            if (_currentMapInstance != null)
            {
                return _currentMapInstance.Name;
            }
            return "";
        }
    }
}
