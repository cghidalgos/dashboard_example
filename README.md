# Base de datos: ESTUDIANTES_VIDEOJUEGOS

## Introducción

Esta base de datos simula el ecosistema académico y de juego de estudiantes universitarios para analizar hábitos y patrones de uso de videojuegos. Incluye entidades como estudiantes, programas académicos, semestres, hábitos de juego, videojuegos, géneros, plataformas y sesiones de juego, con relaciones entre ellas para permitir análisis descriptivos útiles.

Objetivo del ejercicio: cada estudiante debe formular una pregunta de negocio/analítica (por ejemplo, “¿qué plataformas usan más los estudiantes de mi programa?”, “¿cuáles son los picos de juego por franja horaria?”, “¿qué géneros concentran más horas por semana?”) y responderla construyendo visualizaciones en Looker Studio a partir de esta base.

Sugerencia: para conectarte desde Looker Studio, usa la vista unificada `v_unificado_looker` (ver sección más abajo) o las vistas KPI (`sql/kpis.sql`) como fuentes de datos.

## 1) Crear cuenta en Supabase

- Abre: https://supabase.com/dashboard/sign-in?returnTo=%2Forganizations
- Regístrate/inicia sesión con tu cuenta de GitHub.

## 2) Crear un proyecto en Supabase

- Crea un nuevo proyecto. Esto te aprovisiona una base de datos PostgreSQL gestionada.
- Conserva la contraseña del proyecto: la necesitarás para conectar herramientas externas.

## 3) Cargar el esquema (DDL) y los datos (DML)

- En el proyecto de Supabase ve a: SQL Editor.
- Abre el archivo `DDL.sql` de este repositorio, copia su contenido en el editor y presiona Run/Ejecutar.
- Luego abre `DML.sql`, copia su contenido y ejecútalo también.
- Opcional pero recomendado: ejecuta `sql/fix_sequences.sql` (incluido en este repo) para alinear las secuencias con los IDs insertados manualmente por el DML.

Con esto tu base queda lista en Supabase.

## 4) Obtener parámetros de conexión

- En Supabase, ve a: Connect → View parameters.
- Copia los valores de: host, database, user y port (la contraseña es la que definiste al crear el proyecto).

## 5) Conectar en Looker Studio (Google Data Studio)

- Abre: https://lookerstudio.google.com/overview e inicia sesión con tu cuenta de Google.
- Haz clic en Crear → Fuente de datos.
- Selecciona el conector PostgreSQL.
- Ingresa los parámetros obtenidos en el paso anterior (host, database, user, password y port). Si ves la opción, deja SSL habilitado.
- Conéctate y selecciona el esquema (por defecto suele ser `public`) y las tablas que quieras explorar.

## 6) Crear informe y visualizar

- Desde la fuente de datos, pulsa “Crear informe” para construir tu dashboard.
- Formula tu pregunta de análisis (por ejemplo: ¿qué plataformas se usan más?, ¿cuántas horas por semana?, ¿qué géneros son más jugados?) y respóndela con visualizaciones.

---

## Preguntas guía

Usa estas ideas para formular tu pregunta y contestarla con visualizaciones en Looker Studio. Elige una o combina varias según tu interés.

- Tendencia y actividad
	- ¿Cuántas horas totales se juegan por semana/mes? ¿La tendencia sube o baja?
	- ¿Cuáles son los picos por día de la semana y franja horaria (Mañana/Tarde/Noche/Madrugada)?
	- ¿Cómo se distribuyen las duraciones de sesión (mediana, p95)?

- Plataformas y tecnologías
	- ¿Qué plataformas concentran más horas y sesiones? ¿Cómo cambia en el tiempo?
	- ¿Web vs. PC vs. Móvil: cuál domina por semana/mes?

- Géneros y títulos
	- ¿Qué géneros acumulan más horas? ¿Hay estacionalidad?
	- ¿Cuáles son los videojuegos top en los últimos 30/60/90 días?

- Perfil de estudiante
	- ¿Quiénes son los estudiantes con más horas (Top N)? ¿Qué patrón de franjas tienen?
	- ¿Existen diferencias por género del estudiante?

- Programas y avance académico
	- Por programa académico: ¿qué tanto se juega (horas/sesiones) y en qué plataformas?
	- Por semestre cursando: ¿cambia el tiempo de juego a medida que avanzan?

- Modalidades de juego
	- ¿Qué proporción de sesiones es Online vs. Solo? ¿Y multijugador vs. no multijugador?
	- ¿Las sesiones Online duran más que las Solo?

- Ventana reciente
	- En los últimos 30/60/90 días: ¿qué cambió en plataformas, géneros y títulos top?

- Calidad de datos (sanidad)
	- ¿Hay sesiones con duración atípica o horas de inicio/fin inconsistentes? ¿Cómo afectan los análisis?

Sugerencia para responder:
- Fuente: `v_unificado_looker` o alguna vista KPI de `sql/kpis.sql`.
- Dimensiones típicas: semana (ISO), mes (YYYY-MM), plataforma, género de juego, videojuego, franja_horaria, programa, estudiante.
- Métricas típicas: total_horas, total_minutos, total_sesiones, duración promedio.
- Filtros útiles: ventana temporal (últimos 30/60/90 días), programa específico, plataforma o género.
- Gráficos recomendados: series de tiempo para tendencia; barras apiladas para plataformas/géneros; tablas con Top N; heatmap por día vs. franja.

## Vista unificada para Looker Studio (importante)

Looker Studio generalmente te deja elegir una sola tabla o vista por fuente. Para tener todas las columnas en una sola entidad, crea una vista unificada:

1) Abre el SQL Editor de Supabase y ejecuta `sql/unified_view.sql` para crear `v_unificado_looker`.
2) En Looker Studio, selecciona `v_unificado_looker` como fuente de datos y construye tus gráficos encima de esta vista.

La vista ya hace los JOIN entre estudiantes, programas, semestres, hábitos, sesiones, videojuegos, géneros y plataformas. Si tu dataset no tiene `id_semestre` poblado en todas partes, está preparada con LEFT JOIN para no perder filas.

Tambien puede copiar y pegar directamente en la consulta personalizada de looker, le quitas la vista `CREATE OR REPLACE VIEW v_unificado_looker AS`

## Referencia del modelo (opcional)

Está escrito para PostgreSQL (uso de `SERIAL`, `BOOLEAN`, `TEXT`, `true/false`). Funciona en Supabase (PostgreSQL 14/15+).

Objetos principales creados por `DDL.sql`:

- estudiantes (PK: id_estudiante)
- programas_academicos (PK: id_programa)
- semestres (PK: id_semestre)
- estudiantes_programas (PK: id_matricula) → FK: estudiantes, programas_academicos, semestres
- plataformas (PK: id_plataforma)
- generos_juegos (PK: id_genero)
- videojuegos (PK: id_videojuego) → FK: generos_juegos
- videojuegos_plataformas (PK compuesta: id_videojuego, id_plataforma) → FK: videojuegos, plataformas
- sesiones_juego (PK: id_sesion) → FK: estudiantes, videojuegos, plataformas, semestres
- resumen_semanal (PK: id_resumen) → FK: estudiantes, semestres
- estadisticas_semestre (PK: id_estadistica) → FK: estudiantes, semestres, videojuegos, plataformas
- habitos_juego (PK: id_habito) → FK: estudiantes, semestres

Notas:

- `semestres` no trae datos en `DML.sql` (puedes poblarla después si lo necesitas).
- Si ejecutarás INSERTs sin especificar IDs, corre `sql/fix_sequences.sql` tras el DML para evitar conflictos con columnas `SERIAL`.

## Vistas KPI listas para usar (opcional)

Puedes crear las vistas ejecutando `sql/kpis.sql` en el SQL Editor de Supabase. Esto genera:

- `v_sesiones_enriquecidas`: sesiones con joins y campos derivados (semana, mes, franja horaria, horas, etc.).
- `kpi_horas_por_semana`: tendencia de horas y sesiones por semana ISO.
- `kpi_horas_por_plataforma`: horas y sesiones por plataforma.
- `kpi_horas_por_genero`: horas y sesiones por género de juego.
- `kpi_top_videojuegos_30dias`: top de videojuegos por horas en los últimos 30 días.
- `kpi_actividad_por_franja`: picos de juego por franja horaria (Mañana/Tarde/Noche/Madrugada).
- `kpi_horas_por_estudiante`: top 50 estudiantes por horas jugadas.
- `kpi_horas_por_mes`: horas y sesiones por mes (YYYY-MM).

En Looker Studio puedes conectarte a estas vistas igual que a tablas y usarlas como fuente para gráficos.

## Alternativa: ejecución local con psql (opcional)

En `scripts/` hay utilidades para macOS/Linux usando `psql` con variables de entorno estándar (PGHOST, PGPORT, PGUSER, PGPASSWORD, PGDATABASE):

- `scripts/apply_ddl.sh` → aplica `DDL.sql`.
- `scripts/apply_dml.sh` → aplica `DML.sql` y luego `sql/fix_sequences.sql`.

Asegúrate de que tu cliente use UTF-8 (hay acentos y caracteres especiales) y formato de fechas/horas ISO.
