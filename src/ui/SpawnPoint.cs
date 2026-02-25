using System;
using Godot;

namespace GameProject
{
    [Tool]
    public partial class SpawnPoint : Marker2D
    {
        [Export] public SpawnData Data { get; private set; }

        public Node2D Spawn()
        {
            return Data switch
            {
                PlayerSpawnData p => SpawnPlayer(p),
                CheckpointSpawnData c => SpawnCheckpoint(c),
                EnemySpawnData e => SpawnEnemy(e),
                ItemSpawnData i => SpawnItem(i),
                _ => throw new Exception("Unknown spawn type")
            };
        }

        private Node2D SpawnItem(ItemSpawnData i)
        {
            throw new NotImplementedException();
        }

        private Node2D SpawnEnemy(EnemySpawnData e)
        {
            throw new NotImplementedException();
        }

        private Node2D SpawnCheckpoint(CheckpointSpawnData c)
        {
            throw new NotImplementedException();
        }

        private Node2D SpawnPlayer(PlayerSpawnData p)
        {
            throw new NotImplementedException();
        }

        public bool IsPlayerSpawn()
        {
            throw new NotImplementedException();
        }

        public bool IsEnemySpawn()
        {
            throw new NotImplementedException();
        }

        public string GetSpawnId()
        {
            return this.Data.SpawnId;
        }

        // private void UpdateEditorVisual();

        public override void _Ready()
        {
            return;
        }
    }
}