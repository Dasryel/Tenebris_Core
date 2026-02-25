
namespace GameProject
{
    public interface IState
    {
        public abstract void Enter(Entity entity);
        public abstract void Exit(Entity entity);
        public abstract void Update(Entity entity, double delta);
    }
}