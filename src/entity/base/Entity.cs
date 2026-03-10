using Godot;
using System;
using System.Collections.Generic;

namespace GameProject
{
    public partial class Entity : CharacterBody2D
    {
        public const string LocomotionLayer = "Locomotion";
        public const string CombatLayer = "Combat";
        public readonly float Speed = 300.0f;
        public readonly float JumpVelocity = -420.0f;
        public readonly float Gravity = 1200f;
        public AnimationPlayer AnimationPlayer { get; private set; }

        private readonly Dictionary<string, StateMachine> _stateMachines = [];

        public override void _Ready()
        {
            AddStateMachine(LocomotionLayer, StateCache.Get<FallingState>());
        }


        public StateMachine GetStateMachine(string layer)
        {
            if (!_stateMachines.TryGetValue(layer, out var sm))
            {
                GD.PushError($"State machine layer '{layer}' not found. " +
                    $"Available layers: {string.Join(", ", _stateMachines.Keys)}");
                return null!;
            }
            return sm;
        }


        protected StateMachine AddStateMachine(string layer, BaseState defaultState)
        {
            if (_stateMachines.ContainsKey(layer))
            {
                GD.PushError($"State machine layer '{layer}' is already registered.");
            }

            var sm = new StateMachine(defaultState);
            _stateMachines[layer] = sm;
            return sm;
        }

        public override void _Process(double delta)
        {
            foreach (var sm in _stateMachines.Values)
            {
                sm.Update(this, delta);
            }
        }
    }
}