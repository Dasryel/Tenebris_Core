
namespace GameProject
{
    public abstract class BaseState
    {
        protected static void GoTo<T>(Entity entity, string layer) where T : BaseState, new()
        {
            entity.GetStateMachine(layer)
                  .ChangeState(StateCache.Get<T>(), entity);
        }

        protected static void GoToLoco<T>(Entity entity) where T : BaseState, new()
            => GoTo<T>(entity, Entity.LocomotionLayer);

        protected static void GoToCombat<T>(Entity entity) where T : BaseState, new()
            => GoTo<T>(entity, Entity.CombatLayer);

        public abstract void Enter(Entity entity);
        public abstract void Update(Entity entity, double delta);
        public abstract void Exit(Entity entity);
    }

}