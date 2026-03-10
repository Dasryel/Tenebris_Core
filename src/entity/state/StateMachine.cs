using Godot;

namespace GameProject
{
    public partial class StateMachine(BaseState defaultState)
    {
        //The currently active state (read-only)
        public BaseState CurrentState => _currentState;

        private BaseState _currentState = defaultState;

        public void ChangeState(BaseState newState, Entity entity)
        {
            _currentState?.Exit(entity);
            _currentState = newState;
            _currentState?.Enter(entity);
        }

        public void Update(Entity entity, double delta)
        {
            _currentState?.Update(entity, delta);
        }
    }
}