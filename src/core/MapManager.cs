using Godot;
using System;

namespace GameProject
{
    public partial class MapManager : Node2D
    {
        public static MapManager Instance { get; private set; }
        private static readonly string stringName = "MapManager";
        // private static MapData mapData;

        private MapData _activeMap;

        public override void _Notification(int what)
        {
            if (what == NotificationPredelete)
            {
                GD.Print($"[{stringName}] is being deleted");
            }
        }

        public override void _Ready()
        {
            Instance = this;
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

        public string GetCurrentMapName()
        {
            if (this._activeMap != null)
            {
                return this._activeMap.Name;
            }
            return "";
        }

        protected override void Dispose(bool disposing)
        {
            if (Instance == this) Instance = null;
            base.Dispose(disposing);
        }
    }
}
