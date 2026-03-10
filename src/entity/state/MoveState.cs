using Godot;

namespace GameProject
{
    public partial class MoveState : BaseState
    {
        public override void Enter(Entity entity)
        {
            // TODO change animation to moving
        }


        public override void Update(Entity entity, double delta)
        {
            if (Input.IsActionJustPressed(GameInput.Jump))
            {
                GoToLoco<JumpState>(entity);
                return;
            }

            float hDir = Input.GetAxis(GameInput.MoveLeft, GameInput.MoveRight);

            if (Mathf.IsZeroApprox(hDir))
            {
                GoToLoco<IdleState>(entity);
                return;
            }

            Vector2 velocity = entity.Velocity;
            velocity.X = hDir * entity.Speed;

            entity.Velocity = velocity;
            entity.MoveAndSlide();
        }


        public override void Exit(Entity entity)
        {

        }
    }
}