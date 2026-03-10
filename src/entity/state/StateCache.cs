using System;
using System.Collections.Generic;

namespace GameProject
{
    /* Flyweight cache, reuses a single instance per stateless Istate type.

       Only valid for states with no mutable instance fields.
       Per-entity states must be instantiated with new
    */
    public static class StateCache
    {
        private static readonly Dictionary<Type, IState> _cache = [];

        public static T Get<T>() where T : IState, new()
        {
            var type = typeof(T);
            if (!_cache.TryGetValue(type, out var state))
            {
                state = new T();
                _cache[type] = state;
            }
            return (T)state;
        }
    }
}
