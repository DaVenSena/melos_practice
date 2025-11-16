# domain

Capa de dominio: modelos puros y contratos de repositorios. Define la lógica de negocio y las reglas que deben cumplir las implementaciones en `data`.

## Contenido
- `models`: entidades de dominio (`Task`, `User`).
- `repositories`: interfaces/contratos para tareas y usuarios.

## Principios
- Sin dependencias de UI ni infraestructura.
- Tipos y contratos estables para favorecer testeo y mantenimiento.

## Uso
Importa desde casos de uso o implementaciones:
```dart
import 'package:domain/domain.dart';
```

## Relación con otras capas
- `features_todo_app` consume `domain` para expresar reglas/casos de uso.
- `data` implementa los contratos definidos en `domain`.

## Licencia
MIT
