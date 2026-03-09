using System;
using System.Collections.Generic;

namespace GameProject
{
    /// <summary>
    /// Flyweight cache for stateless <see cref="IState"/> instances.
    /// Reuses a single cached instance per state type to avoid per-frame allocations
    /// (eliminates memory churn at 60 fps when states transition).
    /// Only use for states with no mutable instance fields; states that require
    /// per-entity data must be instantiated with <c>new</c> directly.
    /// <para>
    /// Thread safety: Godot's <c>_Process</c> and <c>_Ready</c> callbacks run on
    /// the main thread only, so no synchronization is required here.
    /// </para>
    /// </summary>
    public static class StateCache
    {
        private static readonly Dictionary<Type, IState> _cache = new();

        /// <summary>
        /// Returns the cached singleton for <typeparamref name="T"/>,
        /// creating it on first access.
        /// </summary>
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
