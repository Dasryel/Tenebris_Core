using Godot;

namespace GameProject
{
    public partial class DebugOverlay : Node2D
    {
        private static readonly DebugOverlay _instance = new();
        public static DebugOverlay Instance => _instance;
        private static bool _isEnabled = false;

        private Camera2D _debugCamera;
        private float _cameraMoveSpeed = 2000f;

        public override void _Ready()
        {
            this.Name = "DebugOverlay";
            _instance.Visible = false;
            GD.Print("[DebugOverlay] instance created");
        }


        public override void _Process(double delta)
        {
            if (!_isEnabled)
            {
                return;
            }

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
                this._debugCamera.Position += direction * this._cameraMoveSpeed * (float)delta;
            }
        }


        public override void _Input(InputEvent @event)
        {
            if (@event.IsActionPressed("toggle_debug"))
            {
                GD.Print("[DebugOverlay] Toggling debug mode");
                ToggleOverlay(GetGlobalMousePosition());
            }
        }


        public void ToggleOverlay(Vector2 initialPosition)
        {
            if (!_isEnabled)
            {
                _instance.Visible = true;
                _isEnabled = true;
                SetupDebugCamera(initialPosition);
                return;
            }

            _instance.Visible = false;
            _isEnabled = false;

            _debugCamera?.QueueFree();
            _debugCamera = null;
        }

        public void SetupDebugCamera(Vector2 initialPosition)
        {
            this._debugCamera = new()
            {
                Name = "DebugCamera",
                Enabled = true,
                Position = initialPosition,
            };

            AddChild(this._debugCamera);
            this._debugCamera.MakeCurrent();
            GD.Print("[DebugOverlay] Created debug camera");
        }
    }
}