using Godot;

namespace GameProject
{
    public class CombatIdleState : IState
    {
        public void Enter(Entity entity)
        {
            // TODO transition animation to weapon-lowered / unarmed idle
        }

        public void Update(Entity entity, double _delta)
        {
            if (Input.IsActionPressed("fire"))
            {
                entity.GetStateMachine(Entity.CombatLayer)
                      .ChangeState(StateCache.Get<ShootingState>(), entity);
                return;
            }
        }

        public void Exit(Entity entity) { }
    }
}
