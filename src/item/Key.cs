using Godot;
using System;

namespace GameProject
{
    public partial class Key : Area2D
    {
        [Export] private string _keyName = "GoldKey";
        [Export] private float _hoverAmplitude = 5.0f;
        [Export] private float _hoverSpeed = 4.0f;

        private Vector2 _basePosition;
        private float _timePassed = 0.0f;

        public override void _Ready()
        {
            _basePosition = Position;
            BodyEntered += OnBodyEntered;
        }

        public override void _Process(double delta)
        {
            _timePassed += (float)delta;
            float yOffset = Mathf.Sin(_timePassed * _hoverSpeed) * _hoverAmplitude;
            Position = new Vector2(_basePosition.X, _basePosition.Y + yOffset);
        }

        private void OnBodyEntered(Node2D body)
        {
            if (body.IsInGroup("player"))
            {
                SignalBus.Instance.EmitSignal(SignalBus.SignalName.KeyCollected, _keyName);
                QueueFree();
            }
        }
    }
}