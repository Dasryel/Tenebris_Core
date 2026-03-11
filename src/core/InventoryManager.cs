using Godot;
using System;
using System.Collections.Generic;

namespace GameProject
{
    public partial class InventoryManager : Node
    {
        public static InventoryManager Instance { get; private set; }
        private static readonly string stringName = "InventoryManager";
        private readonly List<string> _keys = [];

        public override void _Notification(int what)
        {
            if (what == NotificationPredelete)
            {
                GD.Print($"[{stringName}] is being deleted");
            }
        }

        public override void _Ready()
        {
            Instance = this;
            Name = stringName;
            SignalBus.Instance.KeyCollected += AddKey;
        }

        private void AddKey(string keyType)
        {
            _keys.Add(keyType);
            GD.Print($"Inventory: Now carrying {keyType}");
        }

        protected override void Dispose(bool disposing)
        {
            if (Instance == this) Instance = null;
            base.Dispose(disposing);
        }
    }
}