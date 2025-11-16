# Todo App

Aplicación Flutter de tareas (To‑Do) construida sobre un monorepo con separación por capas y paquetes. Esta app consume los casos de uso del paquete `features_todo_app`, los modelos/contratos del paquete `domain`, las implementaciones en `data` y los componentes UI reutilizables de `core_ui` junto con utilidades comunes de `core_utils`.

## Arquitectura (alto nivel)

- **domain**: modelos (`Task`, `User`) y contratos de repositorios.
- **data**: implementación de repositorios y fuentes de datos locales.
- **features_todo_app**: casos de uso (auth y tasks) que orquestan `domain` y `data`.
- **core_ui**: componentes UI reutilizables.
- **core_utils**: utilidades y helpers compartidos.

## Requisitos

- Flutter estable instalado
- Melos para manejar el monorepo

## Primeros pasos

1. Instalar dependencias del monorepo:

```bash
melos bootstrap
```

2. Ejecutar la app:

```bash
flutter run
```

## Estructura relevante

- `lib/app`: arranque de la app y preferencias.
- `lib/presentation`: vistas y providers que consumen casos de uso desde `features_todo_app`.

## Tests

Ejecutar pruebas del monorepo:

```bash
melos test
```

## Licencia

MIT
