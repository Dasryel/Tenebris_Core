using Godot;

namespace GameProject
{
    [GlobalClass]
    public partial class SpawnData : Resource
    {
        [Export] public string SpawnId { get; set; }
        // injected in MapData.SortSpawnPoints(), was difficult to do otherwise
        public Vector2 GlobalSpawnPosition { get; set; }
    }
}