namespace GameProject
{
    public class StateMachine(IState defaultState)
    {
        private IState _currentState = defaultState;

        /// <summary>The currently active state (read-only).</summary>
        public IState CurrentState => _currentState;

        public void ChangeState(IState newState, Entity entity)
        {
            _currentState.Exit(entity);
            _currentState = newState;
            _currentState.Enter(entity);
        }

        public void Update(Entity entity, double delta)
        {
            _currentState.Update(entity, delta);
        }
    }
}