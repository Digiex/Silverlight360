# System.Reflection

Assembly: `mscorlib.dll`

| Type | Summary |
|---|---|
| [`ReflectionPermissionFrame`](#reflectionpermissionframe) | Represents a runtime stack frame that temporarily relaxes reflection permission checks for the code that pushes it. |

## ReflectionPermissionFrame

`struct System.Reflection.ReflectionPermissionFrame`

Represents a runtime stack frame that temporarily relaxes reflection permission checks for the code that pushes it.

This structure is security critical and used by the platform itself; application code cannot use it.

**Methods**

| | |
|---|---|
| `System.Void Pop()` | Removes the frame from the current thread's frame chain. |
| `System.Void Push(System.Reflection.ReflectionPermissionFrame.PermissionFlag flag)` | Pushes the frame onto the current thread's frame chain with the specified permissions. Every Push must be matched by a call to [`ReflectionPermissionFrame.Pop`](System.Reflection.md#reflectionpermissionframe) on the same thread. |

