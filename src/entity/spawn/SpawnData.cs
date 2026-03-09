using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class SpawnData : Resource
    {
        [Export] public string SpawnId { get; set; }
        public Vector2 GlobalPosition { get; set; }
    }
}