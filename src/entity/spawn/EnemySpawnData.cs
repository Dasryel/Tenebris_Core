using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class EnemySpawnData : SpawnData
    {
        [Export] public PackedScene EnemyScene { get; set; }
        [Export] public float PatrolRadius { get; set; }
        [Export] public bool RespawnOnMapReload { get; set; }
    }
}