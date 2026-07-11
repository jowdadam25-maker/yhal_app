# YHLA Architecture Rules (Official)

1) Source of truth
- Current approved tree is the only valid structure.

2) State management
- Riverpod only.
- Do NOT use bloc/cubit/controller folders.

3) Feature structure (mandatory)
feature/
  data/
    datasources/remote
    datasources/local
    dto/
    models/
    mappers/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    pages/
    widgets/
    providers/
    state/

4) Layer boundaries
- UI code only in presentation.
- Domain must not import Flutter/Firebase.
- Data implements domain repositories.
- Firebase SDK code only inside lib/infrastructure/firebase.

5) Shared/Core rules
- Config only in lib/core/config.
- Reusable UI in lib/shared.
- No duplicate responsibility across core/shared/infrastructure.

6) Naming
- snake_case for files/folders.
- Keep existing names unless explicitly requested.

7) Scope control
- No new top-level folders.
- No structural moves without explicit request.

8) Dependency Injection
- All dependencies must be registered only in lib/app/di.
- Do not create service locators inside features.

9) Design System
- All reusable UI components must be created in lib/design_system or lib/shared.
- Do not duplicate buttons/cards/inputs/dialogs/themes inside features.
