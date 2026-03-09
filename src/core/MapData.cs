using System.Collections.Generic;
using System.Linq;
using Godot;

namespace GameProject
{
    public partial class MapData : Node2D
    {
        [Export] public string MapId { get; set; }
        public List<PlayerSpawnData> PlayerSpawns { get; private set; } = [];
        public List<CheckpointSpawnData> Checkpoints { get; private set; } = [];
        public List<EnemySpawnData> EnemySpawns { get; private set; } = [];
        public List<ItemSpawnData> ItemSpawns { get; private set; } = [];

        private List<SpawnPoint> _spawns;

        public override void _Ready()
        {
            Node2D allSpawns = GetNode<Node2D>("Spawns");
            _spawns = [.. allSpawns.GetChildren().OfType<SpawnPoint>()];
            SortSpawnPoints();

            GD.Print("[MapData] map data loaded");
        }


        public virtual Rect2 GetBounds()
        {
            return GetNode<Node2D>("RoomBounds")
                       .GetNode<CollisionShape2D>("Shape")
                       .Shape.GetRect(); // or however you define it
        }


        public PlayerSpawnData GetDefaultPlayerSpawn()
        {
            PlayerSpawnData defaultSpawn = PlayerSpawns.FirstOrDefault(p => p.IsDefault);

            if (defaultSpawn != null)
            {
                return defaultSpawn;
            }
            return PlayerSpawns.FirstOrDefault();
        }


        public PlayerSpawnData GetPlayerSpawn(string spawnId)
        {
            return PlayerSpawns.FirstOrDefault(p => p.SpawnId == spawnId);
        }


        public CheckpointSpawnData GetCheckpoint(string spawnId)
        {
            return Checkpoints.FirstOrDefault(c => c.SpawnId == spawnId);
        }


        private void SortSpawnPoints()
        {
            foreach (var spawn in _spawns)
            {
                var data = spawn.Data;
                if (data == null)
                {
                    GD.PrintErr($"Marker2D '{spawn.Name}' has no data assigned!");
                    continue;
                }

                // Inject the Marker2D's position to SpawnData
                data.GlobalPosition = spawn.GlobalPosition;

                switch (data)
                {
                    case PlayerSpawnData p: PlayerSpawns.Add(p); break;
                    case CheckpointSpawnData c: Checkpoints.Add(c); break;
                    case EnemySpawnData e: EnemySpawns.Add(e); break;
                    case ItemSpawnData i: ItemSpawns.Add(i); break;
                    default:
                        GD.PrintErr($"Unknown SpawnData type: {spawn.GetType()} id={spawn.GetSpawnId()}");
                        break;
                }
            }
        }
    }
}