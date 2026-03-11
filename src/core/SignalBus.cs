using Godot;
using System;

namespace GameProject
{
    public partial class SignalBus : Node2D
    {

        // [MapManager]
        [Signal] public delegate void MapLoadedEventHandler(MapData loadedMapInstance);
        [Signal] public delegate void PlayerCreatedEventHandler(Player newPlayer);
        [Signal] public delegate void NewGameEventHandler();

        [Signal] public delegate void KeyCollectedEventHandler(string keyName);

        public static SignalBus Instance { get; private set; }
        private static readonly string stringName = "SignalBus";

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
        }

        protected override void Dispose(bool disposing)
        {
            if (Instance == this) Instance = null;
            base.Dispose(disposing);
        }
    }
}
