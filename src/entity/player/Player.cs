using Godot;

namespace GameProject
{
    public partial class Player : Entity
    {
        public override void _Ready()
        {
            base._Ready();

            // Add the upper-body combat layer alongside the inherited locomotion layer.
            // Both layers update independently every frame, so the player can, for
            // example, move (locomotion) and shoot (combat) at the same time.
            AddStateMachine(CombatLayer, StateCache.Get<CombatIdleState>());
        }
    }
}