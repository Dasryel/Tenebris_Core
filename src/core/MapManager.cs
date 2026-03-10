using Godot;
using System;

namespace GameProject
{
    public partial class MapManager : Node2D
    {
        private static readonly MapManager _instance = new();
        public static MapManager Instance => _instance;
        private static readonly string stringName = "MapManager";
        // private static MapData mapData;

        private static MapData _activeMap;

        public override void _Ready()
        {
            Name = stringName;
            GD.Print($"[{stringName}] instance created");
        }


        public bool LoadMap(string scenePath)
        {
            if (!FileAccess.FileExists(scenePath))
            {
                GD.PrintErr($"[{stringName}] Map path not found: {scenePath}");
                return false;
            }

            // Unload previous map
            _activeMap?.QueueFree();

            // Load new map
            PackedScene mapScene = ResourceLoader.Load<PackedScene>(scenePath);
            _activeMap = mapScene.Instantiate<MapData>();

            AddChild(_activeMap);

            SignalBus.Instance.EmitSignal(
                 SignalBus.SignalName.MapLoaded,
                 _activeMap
                 );

            GD.Print($"[{stringName}] Loaded map: {scenePath}");

            return true;
        }

        public static string GetCurrentMapName()
        {
            if (_activeMap != null)
            {
                return _activeMap.Name;
            }
            return "";
        }
    }
}
