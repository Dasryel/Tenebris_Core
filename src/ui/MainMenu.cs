using Godot;
using System;

namespace GameProject
{
    public partial class MainMenu : Control
    {
        [Export] private Control _menuButtonsVBoxContainer;
        [Export] private Control _optionsPanel;

        [Export] private Button _startButton;
        [Export] private Button _optionsButton;
        [Export] private Button _quitButton;

        [Export] private Button _backButton;
        [Export] private CheckButton _fullscreenCheckButton;

        public override void _Ready()
        {
            _startButton.Pressed += OnStartPressed;
            _optionsButton.Pressed += () => ToggleOptions(true);
            _quitButton.Pressed += () => GetTree().Quit();
            _backButton.Pressed += () => ToggleOptions(false);
            _fullscreenCheckButton.Toggled += OnFullscreenToggled;

            ToggleOptions(false);

            _fullscreenCheckButton.ButtonPressed = DisplayServer.WindowGetMode() == DisplayServer.WindowMode.Fullscreen;
        }

        private void OnStartPressed()
        {
            GD.Print("Start Game Logic Here");
            SignalBus.Instance.EmitSignal(SignalBus.SignalName.NewGame);
        }

        private void ToggleOptions(bool showOptions)
        {
            _optionsPanel.Visible = showOptions;
            _menuButtonsVBoxContainer.Visible = !showOptions;
        }

        private void OnFullscreenToggled(bool isToggled)
        {
            if (isToggled)
            {
                DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
            }
            else
            {
                DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
            }
        }
    }
}