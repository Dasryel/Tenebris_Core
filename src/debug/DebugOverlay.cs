using Godot;

namespace GameProject
{
    public partial class DebugOverlay : CanvasLayer
    {
        public static DebugOverlay Instance => _instance;

        // DebugToolbar
        [Export] public OptionButton MapOptionButton { get; set; }
        [Export] public Button ResetMapButton { get; set; }
        [Export] public Button SpawnAtPointButton { get; set; }
        [Export] public Button FreezeAIButton { get; set; }
        [Export] public Button GodModeButton { get; set; }
        [Export] public HSlider TimeScaleSlider { get; set; }

        // StatsPanel
        [Export] public Label FPSLabel { get; set; }
        [Export] public Label PositionLabel { get; set; }
        [Export] public Label VelocityLabel { get; set; }
        [Export] public Label MapLabel { get; set; }
        [Export] public Label PlayerStateLabel { get; set; }

        private static readonly DebugOverlay _instance = new();
        private DebugCamera _debugCamera;


        public override void _Ready()
        {
            this.Name = "DebugOverlay";
            _instance.Visible = false;
            GD.Print("[DebugOverlay] instance created");
        }


        public override void _Process(double delta)
        {
#if DEBUG
            if (!Visible) return;
            FPSLabel.Text = $"FPS: {Engine.GetFramesPerSecond()}";
            PositionLabel.Text = $"Pos: TODO";
            VelocityLabel.Text = $"Vel: TODO";
            MapLabel.Text = $"Room: {MapManager.GetCurrentMapName()}.tscn";
            PlayerStateLabel.Text = $"State: TODO";
#endif
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
        }

        public override void _ExitTree()
        {
            _debugCamera?.Free();
            _debugCamera = null;
        }











    }
}