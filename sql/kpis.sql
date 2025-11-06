-- Vistas y consultas KPI para la base ESTUDIANTES_VIDEOJUEGOS
-- Ejecuta este archivo en el SQL Editor de Supabase (o psql) después de cargar DDL.sql y DML.sql

-- ============================================
-- Vista base: sesiones enriquecidas
-- Une sesiones con catálogos y agrega campos de fecha/tiempo útiles
-- ============================================
CREATE OR REPLACE VIEW v_sesiones_enriquecidas AS
SELECT
  sj.id_sesion,
  sj.fecha_sesion::date                                          AS fecha_sesion,
  date_trunc('week', sj.fecha_sesion)::date                      AS semana_inicio,
  EXTRACT(isoyear FROM sj.fecha_sesion)::int                     AS anio_iso,
  EXTRACT(week FROM sj.fecha_sesion)::int                        AS semana_iso,
  to_char(sj.fecha_sesion, 'YYYY-MM')                            AS anio_mes,
  EXTRACT(isodow FROM sj.fecha_sesion)::int                      AS dia_semana_iso,
  sj.hora_inicio,
  sj.hora_fin,
  CASE
    WHEN sj.hora_inicio IS NULL THEN 'Desconocido'
    WHEN sj.hora_inicio >= TIME '05:00' AND sj.hora_inicio < TIME '12:00' THEN 'Mañana'
    WHEN sj.hora_inicio >= TIME '12:00' AND sj.hora_inicio < TIME '18:00' THEN 'Tarde'
    WHEN sj.hora_inicio >= TIME '18:00' AND sj.hora_inicio < TIME '23:00' THEN 'Noche'
    ELSE 'Madrugada'
  END                                                            AS franja_horaria,
  sj.duracion_minutos                                            AS minutos,
  round(sj.duracion_minutos / 60.0, 2)                           AS horas,
  sj.tipo_sesion,
  e.id_estudiante,
  trim(coalesce(e.nombre,'') || ' ' || coalesce(e.apellido,''))  AS estudiante,
  v.id_videojuego,
  v.nombre                                                       AS videojuego,
  g.id_genero,
  g.nombre                                                       AS genero,
  p.id_plataforma,
  p.nombre                                                       AS plataforma,
  v.es_online,
  v.es_multijugador
FROM sesiones_juego sj
LEFT JOIN estudiantes e ON e.id_estudiante = sj.id_estudiante
LEFT JOIN videojuegos v ON v.id_videojuego = sj.id_videojuego
LEFT JOIN generos_juegos g ON g.id_genero = v.id_genero
LEFT JOIN plataformas p ON p.id_plataforma = sj.id_plataforma;

-- ============================================
-- KPI: Horas por semana (ISO)
-- ============================================
CREATE OR REPLACE VIEW kpi_horas_por_semana AS
SELECT
  semana_inicio,
  anio_iso,
  semana_iso,
  SUM(horas)      AS total_horas,
  SUM(minutos)    AS total_minutos,
  COUNT(*)        AS total_sesiones
FROM v_sesiones_enriquecidas
GROUP BY semana_inicio, anio_iso, semana_iso
ORDER BY semana_inicio;

-- ============================================
-- KPI: Horas por plataforma
-- ============================================
CREATE OR REPLACE VIEW kpi_horas_por_plataforma AS
SELECT
  plataforma,
  SUM(horas)   AS total_horas,
  COUNT(*)     AS total_sesiones
FROM v_sesiones_enriquecidas
GROUP BY plataforma
ORDER BY total_horas DESC;

-- ============================================
-- KPI: Horas por género de juego
-- ============================================
CREATE OR REPLACE VIEW kpi_horas_por_genero AS
SELECT
  genero,
  SUM(horas)   AS total_horas,
  COUNT(*)     AS total_sesiones
FROM v_sesiones_enriquecidas
GROUP BY genero
ORDER BY total_horas DESC;

-- ============================================
-- KPI: Top videojuegos últimos 30 días
-- ============================================
CREATE OR REPLACE VIEW kpi_top_videojuegos_30dias AS
SELECT
  videojuego,
  SUM(horas)   AS total_horas,
  COUNT(*)     AS total_sesiones
FROM v_sesiones_enriquecidas
WHERE fecha_sesion >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY videojuego
ORDER BY total_horas DESC
LIMIT 20;

-- ============================================
-- KPI: Actividad por franja horaria
-- ============================================
CREATE OR REPLACE VIEW kpi_actividad_por_franja AS
SELECT
  franja_horaria,
  SUM(horas)   AS total_horas,
  COUNT(*)     AS total_sesiones
FROM v_sesiones_enriquecidas
GROUP BY franja_horaria
ORDER BY total_sesiones DESC;

-- ============================================
-- KPI: Horas por estudiante (Top 50)
-- ============================================
CREATE OR REPLACE VIEW kpi_horas_por_estudiante AS
SELECT
  id_estudiante,
  estudiante,
  SUM(horas)   AS total_horas,
  COUNT(*)     AS total_sesiones
FROM v_sesiones_enriquecidas
GROUP BY id_estudiante, estudiante
ORDER BY total_horas DESC
LIMIT 50;

-- ============================================
-- KPI: Horas por mes (YYYY-MM)
-- ============================================
CREATE OR REPLACE VIEW kpi_horas_por_mes AS
SELECT
  anio_mes,
  SUM(horas)   AS total_horas,
  COUNT(*)     AS total_sesiones
FROM v_sesiones_enriquecidas
GROUP BY anio_mes
ORDER BY anio_mes;


-- ============================================
-- Consultas de ejemplo (opcionales)
-- (Puedes correrlas en el editor para validar las vistas)
-- ============================================
-- 1) Tendencia semanal de horas
-- SELECT * FROM kpi_horas_por_semana LIMIT 100;

-- 2) Plataformas más usadas por horas
-- SELECT * FROM kpi_horas_por_plataforma;

-- 3) Géneros preferidos
-- SELECT * FROM kpi_horas_por_genero;

-- 4) Top videojuegos en últimos 30 días
-- SELECT * FROM kpi_top_videojuegos_30dias;

-- 5) Picos de juego por franja horaria
-- SELECT * FROM kpi_actividad_por_franja;

-- 6) Top 50 estudiantes por horas jugadas
-- SELECT * FROM kpi_horas_por_estudiante;

-- 7) Horas por mes
-- SELECT * FROM kpi_horas_por_mes;
