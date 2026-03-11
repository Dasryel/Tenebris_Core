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

        private static readonly SignalBus _instance = new();
        public static SignalBus Instance => _instance;
        private static readonly string stringName = "SignalBus";


        public override void _Ready()
        {
            Name = stringName;
            return;
        }

        private SignalBus() { }
    }
}
