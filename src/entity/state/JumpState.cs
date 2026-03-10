using Godot;

namespace GameProject
{
    public partial class JumpState : IState
    {
        public void Enter(Entity entity)
        {
            Vector2 velocity = entity.Velocity;
            velocity.Y = entity.JumpVelocity;
            entity.Velocity = velocity;

            // TODO: Play jump animation
        }

        public void Update(Entity entity, double delta)
        {
            Vector2 velocity = entity.Velocity;
            velocity.Y += entity.Gravity * (float)delta;

            float hDir = Input.GetAxis(GameInput.MoveLeft, GameInput.MoveRight);
            velocity.X = hDir * entity.Speed;

            entity.Velocity = velocity;
            entity.MoveAndSlide();


            if (entity.Velocity.Y > 0)
            {
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<FallingState>(), entity);
                return;
            }
        }

        public void Exit(Entity entity)
        {
            // TODO cancel / finish shoot animation if interrupted
        }
    }
}
