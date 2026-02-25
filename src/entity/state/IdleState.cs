using Godot;
using System;

namespace GameProject
{
    public partial class IdleState : IState
    {
        public void Enter(Entity entity)
        {
            // TODO change animation to idle
        }


        public void Update(Entity entity, double _delta)
        {
            Vector2 direction = Input.GetVector("left", "right", "up", "down");

            if (direction != Vector2.Zero)
            {
                entity.StateMachine.ChangeState(new MoveState(), entity);
            }
        }


        public void Exit(Entity entity)
        {

        }
    }
}