namespace GameProject
{
    public class StateMachine
    {
        private IState _currentState;

        public StateMachine(IState defaultState)
        {
            _currentState = defaultState;
        }

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