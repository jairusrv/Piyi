# Hotfix 11A.2

Agrega en `Business.cs`:

```csharp
public bool IsProviderPro { get; set; } = false;
```

Luego EF Core generará la columna:

```text
Businesses.IsProviderPro
```

con la migración `BetaCatalogInformationalPro`.
