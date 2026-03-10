using System;
using System.Collections.Generic;

namespace GameProject
{
    /* Flyweight cache, reuses a single instance per stateless BaseState type.

       Only valid for states with no mutable instance fields.
       Per-entity states must be instantiated with new
    */
    public static class StateCache
    {
        private static readonly Dictionary<Type, BaseState> _cache = [];

        public static T Get<T>() where T : BaseState, new()
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
