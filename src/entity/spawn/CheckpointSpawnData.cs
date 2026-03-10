using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class CheckpointSpawnData : SpawnData
    {
        [Export] public string CheckpointId { get; set; }
        // TODO art for checkpoint?
        [Export] public PackedScene VisualScene { get; set; }
    }
}