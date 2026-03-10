using Godot;

namespace GameProject
{
    public partial class FallingState : IState
    {
        private const float AirControlMultiplier = 0.2f;

        public void Enter(Entity entity)
        {
            // TODO: trigger falling animation
        }

        public void Update(Entity entity, double delta)
        {
            float fDelta = (float)delta;

            // Apply gravity
            entity.Velocity += entity.GetGravity() * fDelta;

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
                var loco = entity.GetStateMachine(Entity.LocomotionLayer);
                loco.ChangeState(StateCache.Get<IdleState>(), entity);
                return;
            }
        }

        public void Exit(Entity entity)
        {
        }
    }
}
