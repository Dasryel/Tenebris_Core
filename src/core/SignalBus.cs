using Godot;
using System;

namespace GameProject
{
    public partial class SignalBus : Node2D
    {

        // [MapManager]
        [Signal] public delegate void MapLoadedEventHandler(MapData loadedMapInstance);
        [Signal] public delegate void PlayerCreatedEventHandler(Player newPlayer);

        private static readonly SignalBus _instance = new();
        public static SignalBus Instance => _instance;
        // private static new readonly string Name = "SignalBus";


        public override void _Ready()
        {
            return;
        }

        private SignalBus() { }
    }
}
