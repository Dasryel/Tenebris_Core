using Godot;
using System;

namespace GameProject
{
    public partial class GameManager : Node
    {
        public static GameManager Instance { get; private set; }

        private static readonly string stringName = "GameManager";
        private static Player _currentPlayer;

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
            SignalBus.Instance.PlayerCreated += OnPlayerCreated;
        }

        public override void _ExitTree()
        {
            base._ExitTree();
            _currentPlayer = null;
        }

        private void OnPlayerCreated(Player newPlayer)
        {
            _currentPlayer?.QueueFree();
            _currentPlayer = newPlayer;
            AddChild(_currentPlayer);
            GD.Print($"[{Name}] Added new Player");
        }

        protected override void Dispose(bool disposing)
        {
            if (Instance == this) Instance = null;
            base.Dispose(disposing);
        }
    }
}