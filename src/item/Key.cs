using Godot;

namespace GameProject
{

    public partial class Key : Area2D
    {
        [Export] private string _keyName = "GoldKey";

        public override void _Ready()
        {
            GD.Print("key ready");
            BodyEntered += OnBodyEntered;
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