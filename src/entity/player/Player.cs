using Godot;

namespace GameProject
{
    public partial class Player : Entity
    {
        [Export] public Label StateLabel;

        public override void _Ready()
        {
            base._Ready();

            // Add the upper-body combat layer alongside the inherited locomotion layer.
            // Both layers update independently every frame, so the player can, for
            // example, move (locomotion) and shoot (combat) at the same time.
            AddStateMachine(CombatLayer, StateCache.Get<CombatIdleState>());
        }


        public override void _Process(double delta)
        {
            base._Process(delta);

            var sm = GetStateMachine(LocomotionLayer);
            if (sm == null) return;

            var currentState = sm.CurrentState;
            if (currentState == null)
            {
                StateLabel.Text = "State: Initializing...";
                return;
            }

            StateLabel.Text = $"State: {currentState.GetType().Name}";
        }
    }
}