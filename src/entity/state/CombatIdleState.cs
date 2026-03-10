using Godot;

namespace GameProject
{
    public class CombatIdleState : BaseState
    {
        public override void Enter(Entity entity)
        {
            // TODO transition animation to weapon-lowered / unarmed idle
        }

        public override void Update(Entity entity, double _delta)
        {
            if (Input.IsActionPressed("fire"))
            {
                GoToCombat<ShootingState>(entity);
                return;
            }
        }

        public override void Exit(Entity entity) { }
    }
}
