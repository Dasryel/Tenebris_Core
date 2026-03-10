using Godot;

namespace GameProject
{
    public class ShootingState : BaseState
    {
        public override void Enter(Entity entity)
        {
            // TODO trigger shoot animation; spawn projectile via Gun node
        }

        public override void Update(Entity entity, double _delta)
        {
            if (!Input.IsActionPressed("fire"))
            {
                GoToCombat<CombatIdleState>(entity);
                return;
            }
        }

        public override void Exit(Entity entity)
        {
            // TODO cancel / finish shoot animation if interrupted
        }
    }
}
