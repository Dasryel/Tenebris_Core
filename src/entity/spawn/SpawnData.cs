using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class SpawnData : Resource
    {
        [Export] public string SpawnId { get; set; }
        [Export] public bool IsInitial { get; set; }
    }
}