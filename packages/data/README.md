# data

Implementaciones de repositorios y fuentes de datos que satisfacen los contratos definidos en `domain`. Este paquete se encarga de la persistencia/local storage y del mapeo entre entidades de datos y modelos de dominio.

## Responsabilidades
- Implementar `TasksRepository` y `UsersRepository`.
- Definir `DataSource`(s) y acceso a almacenamiento local.
- Mapear `entities` ⇄ `models` del dominio.

## Estructura
- `lib/data_source`: fuentes de datos (por ejemplo, DB local).
- `lib/entities`: representaciones internas de datos.
- `lib/repositories`: implementaciones concretas de repositorios.

## Dependencias
- Almacenamiento local (por ejemplo, SQLite a través de `sqflite`) según la configuración del proyecto.

## Uso
Este paquete no se usa directamente desde la UI. Es consumido por `features_todo_app` para orquestar casos de uso, y por `domain` para cumplir los contratos.

## Buenas prácticas
- Mantén las dependencias externas encapsuladas aquí.
- No filtrar detalles de infraestructura hacia `domain` o `presentation`.

## Licencia
MIT
