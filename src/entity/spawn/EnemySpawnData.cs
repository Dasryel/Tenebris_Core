using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class EnemySpawnData : SpawnData
    {
        [Export] public PackedScene EnemyScene { get; private set; }
        [Export] public float PatrolRadius { get; private set; }
        [Export] public bool RespawnOnMapReload { get; private set; }
    }
}