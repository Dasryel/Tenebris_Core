using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class PlayerSpawnData : SpawnData
    {
        [Export] public Vector2 FacingDirection { get; set; }
        [Export] public bool IsDefault { get; set; }
    }
}