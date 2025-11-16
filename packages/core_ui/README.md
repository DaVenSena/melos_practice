# core_ui

Componentes de UI reutilizables para Flutter dentro del monorepo. Centraliza botones, icon buttons y demás widgets comunes para mantener consistencia visual y facilitar el mantenimiento.

## ¿Qué incluye?
- `CustomElevatedButton`
- `CustomIconButton`
- `CustomTextButton`

## Instalación (monorepo con Melos)
Las apps/paquetes del monorepo ya resuelven esta dependencia vía `path`. Tras `melos bootstrap`, puedes importar:
```dart
import 'package:core_ui/custom_elevated_button.dart';
```

## Uso rápido
```dart
CustomElevatedButton(
  label: 'Guardar',
  onPressed: () { /* acción */ },
)
```

## Buenas prácticas
- Mantén los estilos y comportamiento de los componentes en este paquete para evitar duplicación.
- Si un componente se reutiliza en más de un módulo, muévelo aquí.

## Licencia
MIT
