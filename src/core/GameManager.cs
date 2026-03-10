using Godot;
using System;

namespace GameProject
{
    public partial class GameManager : Node
    {
        private static readonly GameManager _instance = new();
        public static GameManager Instance => _instance;
        private static readonly string stringName = "GameManager";

        private static Player _currentPlayer;

        public override void _Ready()
        {
            Name = stringName;
            SignalBus.Instance.PlayerCreated += OnPlayerCreated;
        }


        private void OnPlayerCreated(Player newPlayer)
        {
            _currentPlayer?.QueueFree();
            _currentPlayer = newPlayer;
            AddChild(_currentPlayer);
            GD.Print($"[{Name}] Added new Player");
        }
    }
}