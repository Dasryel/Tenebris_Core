using Godot;
using System;
using System.Collections.Generic;

namespace GameProject
{
    public partial class InventoryManager : Node
    {
        private List<string> _keys = new();

        public override void _Ready()
        {
            SignalBus.Instance.KeyCollected += AddKey;
        }

        private void AddKey(string keyType)
        {
            _keys.Add(keyType);
            GD.Print($"Inventory: Now carrying {keyType}");
        }
    }
}