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
            if (Input.IsActionJustPressed(GameInput.Jump))
            {
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<JumpState>(), entity);
                return;
            }

            float hDir = Input.GetAxis(GameInput.MoveLeft, GameInput.MoveRight);

            if (Mathf.IsZeroApprox(hDir))
            {
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<IdleState>(), entity);
                return;
            }

            Vector2 velocity = entity.Velocity;
            velocity.X = hDir * entity.Speed;

            entity.Velocity = velocity;
            entity.MoveAndSlide();
        }


        public void Exit(Entity entity)
        {

        }
    }
}