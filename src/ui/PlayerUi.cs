using Godot;

namespace GameProject
{

    public partial class PlayerUi : Control
    {
        [Export] private TextureRect _keyIcon;
        [Export] private Label _keyLabel;

        public override void _Ready()
        {
            SignalBus.Instance.KeyCollected += OnKeyPickedUp;
            HideKey();
        }

        private async void OnKeyPickedUp(string keyName)
        {
            _keyIcon.Visible = true;
            _keyLabel.Visible = true;

            // TODO display the key's name in the key acquired label
            await ToSignal(GetTree().CreateTimer(2.0), SceneTreeTimer.SignalName.Timeout);

            _keyLabel.Visible = false;
        }

        public void HideKey()
        {
            _keyIcon.Visible = false;
            _keyLabel.Visible = false;
        }
    }
}