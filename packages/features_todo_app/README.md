# features_todo_app

Casos de uso de la aplicación To‑Do. Este paquete orquesta la lógica de negocio usando contratos de `domain` y sus implementaciones en `data`, exponiendo una API clara para la capa de presentación.

## Casos de uso incluidos
- Auth:
  - `sign_in_usecase.dart`
  - `sign_up_usecase.dart`
  - `sign_out_usecase.dart`
- Tasks:
  - `get_tasks_usecase.dart`
  - `add_task_usecase.dart`
  - `update_task_usecase.dart`
  - `delete_task_usecase.dart`
  - `set_done_usecase.dart`

## Uso
Importa y ejecuta desde tus providers/controladores:
```dart
import 'package:features_todo_app/use_cases.dart';
```

## Principios
- Exponer la lógica de negocio lista para ser consumida por la UI.
- Mantener dependencias de infraestructura encapsuladas en `data`.
- Depender de `domain` para modelos/contratos.

## Licencia
MIT
