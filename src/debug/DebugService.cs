using Godot;

namespace GameProject
{
    public partial class DebugService : Node2D
    {
        public static DebugService Instance => _instance;

        private static readonly DebugService _instance = new();
        private DebugOverlay _debugOverlay;
        private bool _isEnabled = false;

        public override void _Input(InputEvent @event)
        {
            if (@event.IsActionPressed("toggle_debug"))
            {
                GD.Print("[DebugOverlay] Toggling debug mode");
                ToggleOverlay(GetGlobalMousePosition());
            }
        }


        public override void _Ready()
        {
            this.Name = "DebugService";
            GD.Print("[DebugService] created");
        }


        public void ToggleOverlay(Vector2 initialPosition)
        {
            if (!_isEnabled)
            {
                PackedScene scene = GD.Load<PackedScene>("res://scene/ui/debug/DebugOverlay.tscn");
                this._debugOverlay = scene.Instantiate<DebugOverlay>();
                AddChild(this._debugOverlay);
                this._isEnabled = true;
                this._debugOverlay.SetupDebugCamera(initialPosition);
                return;
            }

            this._debugOverlay?.QueueFree();
            this._isEnabled = false;
        }

        public override void _ExitTree()
        {
            this._debugOverlay?.Free();
            this._debugOverlay = null;
        }
    }
}