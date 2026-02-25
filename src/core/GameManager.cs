using Godot;
using System;

namespace GameProject
{
    public partial class GameManager : Node
    {
        private Player _currentPlayer;


        public void NewPlayer(Vector2 position)
        {
            _currentPlayer?.QueueFree();
            _currentPlayer = new() { Position = position };
        }
    }
}