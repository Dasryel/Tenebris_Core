using System;
using Godot;

namespace GameProject
{
    public partial class SpawnPoint : Marker2D
    {
        [Export] public SpawnData Data { get; set; }

        public override void _Ready()
        {
            return;
        }

        public string GetSpawnId()
        {
            return this.Data.SpawnId;
        }
    }
}