using Godot;

namespace GameProject
{
    public partial class JumpState : BaseState
    {
        public override void Enter(Entity entity)
        {
            Vector2 velocity = entity.Velocity;
            velocity.Y = entity.JumpVelocity;
            entity.Velocity = velocity;

            // TODO: Play jump animation
        }

        public override void Update(Entity entity, double delta)
        {
            Vector2 velocity = entity.Velocity;
            velocity.Y += entity.Gravity * (float)delta;

            float hDir = Input.GetAxis(GameInput.MoveLeft, GameInput.MoveRight);
            velocity.X = hDir * entity.Speed;

            entity.Velocity = velocity;
            entity.MoveAndSlide();


            if (entity.Velocity.Y > 0)
            {
                GoToLoco<FallingState>(entity);
                return;
            }
        }

        public override void Exit(Entity entity)
        {
            // TODO cancel / finish shoot animation if interrupted
        }
    }
}
