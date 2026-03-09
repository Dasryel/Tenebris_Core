using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class SpawnData : Resource
    {
        [Export] public string SpawnId { get; set; }
    }
}