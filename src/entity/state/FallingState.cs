using Godot;

namespace GameProject
{
    public partial class FallingState : BaseState
    {
        private const float AirControlMultiplier = 0.2f;

        public override void Enter(Entity entity)
        {
            // TODO: trigger falling animation
        }

        public override void Update(Entity entity, double delta)
        {
            float fDelta = (float)delta;

            // Apply gravity
            Vector2 velocity = entity.Velocity;
            velocity.Y += entity.Gravity * fDelta;
            entity.Velocity = velocity;

            // Limited horizontal air control
            Vector2 direction = Input.GetVector(
                GameInput.MoveLeft,
                GameInput.MoveRight,
                GameInput.MoveUp,
                GameInput.MoveDown
            );

            // Floaty limited movement in air
            float targetX = direction.X * entity.Speed * AirControlMultiplier;
            entity.Velocity = new Vector2(
                Mathf.MoveToward(entity.Velocity.X, targetX, entity.Speed * fDelta),
                entity.Velocity.Y
            );

            entity.MoveAndSlide();

            if (entity.IsOnFloor())
            {
                GoToLoco<IdleState>(entity);
                return;
            }
        }

        public override void Exit(Entity entity)
        {
        }
    }
}
