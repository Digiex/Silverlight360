# System.Reflection.ReflectionPermissionFrame

Assembly: `mscorlib.dll`

| Type | Summary |
|---|---|
| [`PermissionFlag`](#permissionflag) | Specifies the reflection permissions granted by a [`ReflectionPermissionFrame`](System.Reflection.md#reflectionpermissionframe). Values can be combined. |

## PermissionFlag

`enum System.Reflection.ReflectionPermissionFrame.PermissionFlag`

Specifies the reflection permissions granted by a [`ReflectionPermissionFrame`](System.Reflection.md#reflectionpermissionframe). Values can be combined.

**Values**

| | |
|---|---|
| `AllowRiskyMethods` | Reflection may invoke methods the runtime otherwise blocks as risky. |
| `BypassTransparencyChecks` | Reflection calls skip security transparency checks. |
| `BypassVisibilityChecks` | Reflection may access members that are not visible to the caller, such as private members. |

