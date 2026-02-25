using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class PlayerSpawnData : SpawnData
    {
        [Export] public Vector2 FacingDirection { get; private set; }
    }
}