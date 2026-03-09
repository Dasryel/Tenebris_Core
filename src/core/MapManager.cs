using Godot;
using System;

namespace GameProject
{
    public partial class MapManager : Node2D
    {
        private static readonly MapManager _instance = new();
        public static MapManager Instance => _instance;
        private static new readonly string Name = "MapManager";
        // private static MapData mapData;

        private static MapData _activeMap;

        public override void _Ready()
        {
            GD.Print($"[{Name}] instance created");
        }


        public bool LoadMap(string scenePath)
        {
            if (!FileAccess.FileExists(scenePath))
            {
                GD.PrintErr($"[{Name}] Map path not found: {scenePath}");
                return false;
            }

            PackedScene mapScene = ResourceLoader.Load<PackedScene>(scenePath);
            _activeMap = mapScene.Instantiate<MapData>();

            AddChild(_activeMap);

            SignalBus.Instance.EmitSignal(
                 SignalBus.SignalName.MapLoaded,
                 _activeMap
                 );

            GD.Print($"[MapManager] Loaded map: {scenePath}");

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
