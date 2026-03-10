using Godot;

namespace GameProject
{
    public class ShootingState : IState
    {
        public void Enter(Entity entity)
        {
            // TODO trigger shoot animation; spawn projectile via Gun node
        }

        public void Update(Entity entity, double _delta)
        {
            if (!Input.IsActionPressed("fire"))
            {
                entity.GetStateMachine(Entity.CombatLayer)
                      .ChangeState(StateCache.Get<CombatIdleState>(), entity);
                return;
            }
        }

        public void Exit(Entity entity)
        {
            // TODO cancel / finish shoot animation if interrupted
        }
    }
}
