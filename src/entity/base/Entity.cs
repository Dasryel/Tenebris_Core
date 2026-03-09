using Godot;
using System;
using System.Collections.Generic;

namespace GameProject
{
    public partial class Entity : CharacterBody2D
    {
        // Layer name constants – used by states and subclasses to address a
        // specific state machine without stringly-typed magic strings at call sites.
        public const string LocomotionLayer = "Locomotion";
        public const string CombatLayer = "Combat";

        public readonly float SPEED = 300.0f;

        // Named state machines support any number of concurrent layers, e.g.
        // locomotion (feet), combat (hands), or N tentacle layers for a boss.
        private readonly Dictionary<string, StateMachine> _stateMachines = new();

        /// <summary>
        /// The locomotion (lower-body / feet) state machine.
        /// Kept as a convenience accessor for backward compatibility.
        /// </summary>
        public StateMachine StateMachine => _stateMachines[LocomotionLayer];

        public AnimationPlayer AnimationPlayer { get; private set; }

        public override void _Ready()
        {
            AddStateMachine(LocomotionLayer, StateCache.Get<IdleState>());
        }

        /// <summary>
        /// Returns the named state machine, allowing states and subclasses to
        /// drive a specific layer (e.g. combat, or "Tentacle3" for a boss).
        /// </summary>
        /// <exception cref="KeyNotFoundException">
        /// Thrown with a descriptive message listing available layers when
        /// <paramref name="layer"/> has not been registered.
        /// </exception>
        public StateMachine GetStateMachine(string layer)
        {
            if (!_stateMachines.TryGetValue(layer, out var sm))
            {
                throw new KeyNotFoundException(
                    $"State machine layer '{layer}' not found. " +
                    $"Available layers: {string.Join(", ", _stateMachines.Keys)}");
            }
            return sm;
        }

        /// <summary>
        /// Registers a new named state machine starting in
        /// <paramref name="defaultState"/>. Call from a subclass <c>_Ready</c>
        /// after <c>base._Ready()</c> to add extra layers.
        /// </summary>
        /// <exception cref="ArgumentException">
        /// Thrown when a state machine for <paramref name="layer"/> is already registered.
        /// </exception>
        protected StateMachine AddStateMachine(string layer, IState defaultState)
        {
            if (_stateMachines.ContainsKey(layer))
            {
                throw new ArgumentException(
                    $"State machine layer '{layer}' is already registered.");
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