using Godot;

namespace GameProject
{

    public partial class Key : Area2D
    {
        [Export] private string _keyName = "GoldKey";

        public override void _Process(double delta)
        {
            // Make the key hover up and down slightly
            float hover = (float)Mathf.Sin(Time.GetTicksMsec() / 200.0f) * 0.2f;
            Position += new Vector2(0, hover);
        }

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