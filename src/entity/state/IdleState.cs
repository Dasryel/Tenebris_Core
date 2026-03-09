using Godot;

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
            Vector2 direction = Input.GetVector("move_left", "move_right", "move_up", "move_down");

            if (direction != Vector2.Zero)
            {
                entity.StateMachine.ChangeState(StateCache.Get<MoveState>(), entity);
            }
        }


        public void Exit(Entity entity)
        {

        }
    }
}