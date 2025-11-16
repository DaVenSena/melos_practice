# core_utils

Utilidades y helpers compartidos entre paquetes y apps del monorepo. Centraliza funciones generales para evitar duplicación y mejorar la mantenibilidad.

## Contenido típico
- Helpers de fechas, validaciones, formateos, comparaciones.
- Extensiones ligeras de tipos comunes.

## Instalación (monorepo con Melos)
Tras `melos bootstrap`, importa lo que necesites:
```dart
import 'package:core_utils/core_utils.dart';
```

## Ejemplo
```dart
final isEmptyOrNull = stringIsNullOrEmpty(miCadena);
```

## Buenas prácticas
- Solo agrega utilidades genéricas y sin dependencias de UI o datos.
- Si una utilidad se vuelve específica de una capa, muévela al paquete correspondiente.

## Licencia
MIT
