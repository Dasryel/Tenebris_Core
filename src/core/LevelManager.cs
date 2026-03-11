using Godot;
using System;
using System.Linq;

namespace GameProject
{
    public partial class LevelManager : Node
    {
        public static LevelManager Instance { get; private set; }

        private static MapData _activeMap;
        private static readonly string stringName = "LevelManager";

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
            SignalBus.Instance.MapLoaded += OnMapLoaded;
        }

        public override void _ExitTree()
        {
            SignalBus.Instance.MapLoaded -= OnMapLoaded;
        }

        private void OnMapLoaded(MapData map)
        {
            _activeMap = map;
            PlayerSpawnData playerSpawn = _activeMap.GetDefaultPlayerSpawn();
            SpawnPlayer(playerSpawn);

        }

        private static void SpawnPlayer(PlayerSpawnData data)
        {
            GD.Print($"[{stringName}] Trying to spawn player");
            string scenePath = "res://scene/entity/player/player.tscn";

            var playerScene = GD.Load<PackedScene>(scenePath);
            if (playerScene == null)
            {
                GD.PrintErr($"[{stringName}] playerScene file was not found at path: {scenePath}");
            }

            var playerInstance = playerScene.Instantiate<Player>();
            if (playerInstance == null)
            {
                GD.PrintErr($"[{stringName}] playerInstance instantiation failed");
            }

            playerInstance.GlobalPosition = data.GlobalSpawnPosition;

            SignalBus.Instance.EmitSignal(
                SignalBus.SignalName.PlayerCreated,
                playerInstance
                );
        }

        protected override void Dispose(bool disposing)
        {
            if (Instance == this) Instance = null;
            base.Dispose(disposing);
        }
    }
}