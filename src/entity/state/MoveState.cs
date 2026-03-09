using Godot;

namespace GameProject
{
    public partial class MoveState : IState
    {
        public void Enter(Entity entity)
        {
            // TODO change animation to moving
        }


        public void Update(Entity entity, double delta)
        {
            Vector2 direction = Input.GetVector("move_left", "move_right", "move_up", "move_down");

            if (direction == Vector2.Zero)
            {
                entity.StateMachine.ChangeState(StateCache.Get<IdleState>(), entity);
                return;
            }


            entity.Velocity = direction.Normalized() * entity.SPEED;
            entity.MoveAndSlide();
        }


        public void Exit(Entity entity)
        {

        }
    }
}