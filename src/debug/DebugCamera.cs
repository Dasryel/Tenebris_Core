using Godot;

namespace GameProject
{
    public partial class DebugCamera : Camera2D
    {
        private float _cameraMoveSpeed = 2000f;

        public override void _Ready()
        {
            GD.Print("[DebugCamera] created");
        }

        public override void _Process(double delta)
        {
            Vector2 direction = Vector2.Zero;

            if (Input.IsActionPressed("move_right"))
                direction.X += 1;
            if (Input.IsActionPressed("move_left"))
                direction.X -= 1;
            if (Input.IsActionPressed("move_down"))
                direction.Y += 1;
            if (Input.IsActionPressed("move_up"))
                direction.Y -= 1;

            if (direction != Vector2.Zero)
            {
                direction = direction.Normalized();
                Position += direction * this._cameraMoveSpeed * (float)delta;
            }
        }
    }
}