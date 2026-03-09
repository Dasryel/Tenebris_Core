using Godot;

namespace GameProject
{
    /// <summary>
    /// Upper-body idle state for the combat layer.
    /// Monitors the fire input and transitions to <see cref="ShootingState"/>
    /// when the player presses the fire button.
    /// </summary>
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
            }
        }

        public void Exit(Entity entity) { }
    }
}
