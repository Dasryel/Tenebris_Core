
namespace GameProject
{
    public interface IState
    {
        // Public and abstract by default in C#
        void Enter(Entity entity);
        void Exit(Entity entity);
        void Update(Entity entity, double delta);
    }
}