using Godot;

namespace GameProject
{
    public partial class IdleState : IState
    {
        public void Enter(Entity entity)
        {
            if (!entity.IsOnFloor())
            {
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<FallingState>(), entity);
                return;
            }

            // TODO change animation to idle
        }


        public void Update(Entity entity, double _delta)
        {
            if (Input.IsActionJustPressed(GameInput.Jump))
            {
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<JumpState>(), entity);
                return;
            }

            Vector2 direction = Input.GetVector(
                GameInput.MoveLeft,
                GameInput.MoveRight,
                GameInput.MoveUp,
                GameInput.MoveDown
                );

            if (direction != Vector2.Zero)
            {
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<MoveState>(), entity);
                return;
            }
        }


        public void Exit(Entity entity)
        {

        }
    }
}