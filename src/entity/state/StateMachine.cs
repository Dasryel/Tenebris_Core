using Godot;

namespace GameProject
{
    public partial class StateMachine(IState defaultState)
    {
        //The currently active state (read-only)
        public IState CurrentState => _currentState;

        private IState _currentState = defaultState;

        public void ChangeState(IState newState, Entity entity)
        {
            _currentState?.Exit(entity);
            _currentState = newState;
            _currentState?.Enter(entity);
        }

        public void Update(Entity entity, double delta)
        {
            //GD.Print($"State: {_currentState}");
            _currentState?.Update(entity, delta);
        }
    }
}