using Godot;

namespace GameProject
{
    [GlobalClass]
    public abstract partial class SpawnData : Resource
    {
        [Export] public string SpawnId { get; private set; }
        [Export] public bool IsInitial { get; private set; }
    }
}