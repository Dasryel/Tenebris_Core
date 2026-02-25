using Godot;
using System;

namespace GameProject
{
    public partial class Entity : CharacterBody2D
    {
        public readonly float SPEED = 300.0f;
        // TODO different state for lower and upper (feet, hands)
        // So entity can be in two different states at the same time, like
        // moving and shooting
        public StateMachine StateMachine { get; private set; }
        public AnimationPlayer AnimationPlayer { get; private set; }

        public override void _Ready()
        {
            StateMachine = new StateMachine(new IdleState());
        }


        public override void _Process(double delta)
        {
            StateMachine.Update(this, delta);
        }
    }
}