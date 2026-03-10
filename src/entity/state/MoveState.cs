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
            Vector2 direction = Input.GetVector(
                GameInput.MoveLeft,
                GameInput.MoveRight,
                GameInput.MoveUp,
                GameInput.MoveDown
                );

            if (direction == Vector2.Zero)
            {
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<IdleState>(), entity);
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