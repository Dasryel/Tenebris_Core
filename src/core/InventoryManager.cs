using Godot;
using System;
using System.Collections.Generic;

namespace GameProject
{
    public partial class InventoryManager : Node
    {
        public static InventoryManager Instance => _instance;

        private static readonly InventoryManager _instance = new();
        private static readonly string stringName = "InventoryManager";
        private readonly List<string> _keys = [];

        public override void _Ready()
        {
            Name = stringName;
            SignalBus.Instance.KeyCollected += AddKey;
        }

        private void AddKey(string keyType)
        {
            _keys.Add(keyType);
            GD.Print($"Inventory: Now carrying {keyType}");
        }
    }
}