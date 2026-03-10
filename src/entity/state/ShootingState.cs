using Godot;

namespace GameProject
{
    /// <summary>
    /// Upper-body shooting state for the combat layer.
    /// Triggers the shoot animation / projectile spawn while the fire button is held,
    /// and returns to <see cref="CombatIdleState"/> when it is released.
    /// </summary>
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
            }
        }

        public void Exit(Entity entity)
        {
            // TODO cancel / finish shoot animation if interrupted
        }
    }
}
