using Godot;

namespace GameProject
{
    public partial class IdleState : BaseState
    {
        public override void Enter(Entity entity)
        {
            if (!entity.IsOnFloor())
            {
                GoToLoco<FallingState>(entity);
                return;
            }

            // TODO change animation to idle
        }


        public override void Update(Entity entity, double _delta)
        {
            if (Input.IsActionJustPressed(GameInput.Jump))
            {
                GoToLoco<JumpState>(entity);
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
                GoToLoco<MoveState>(entity);
                return;
            }
        }


        public override void Exit(Entity entity)
        {

        }
    }
}