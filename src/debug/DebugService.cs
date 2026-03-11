using Godot;

namespace GameProject
{
    public partial class DebugService : Node2D
    {
        public static DebugService Instance { get; private set; }

        private static readonly string stringName = "DebugService";

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
            GD.Print($"[{stringName}] created");
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
            if (IsInstanceValid(_debugOverlay))
            {
                _debugOverlay.QueueFree();
            }
            _debugOverlay = null;
        }

        protected override void Dispose(bool disposing)
        {
            if (Instance == this) Instance = null;
            base.Dispose(disposing);
        }
    }
}