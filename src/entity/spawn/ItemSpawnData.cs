using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class ItemSpawnData : SpawnData
    {
        [Export] public PackedScene ItemScene { get; set; }
        // disappears after pickup
        [Export] public bool Consumable { get; set; }
    }
}