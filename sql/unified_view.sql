-- Vista unificada para Looker Studio
-- Looker suele seleccionar una sola tabla/vista por fuente de datos.
-- Crea esta vista para tener todos los atributos en un único dataset.

CREATE OR REPLACE VIEW v_unificado_looker AS
SELECT 
    e.id_estudiante,
    e.codigo_estudiante,
    e.nombre AS nombre_estudiante,
    e.apellido AS apellido_estudiante,
    e.genero,
    e.email,
    e.fecha_nacimiento,

    -- Programa y semestre
    p.id_programa,
    p.nombre_programa,
    p.facultad,
    ep.semestre_cursando,
    ep.promedio_acumulado,
    ep.estado AS estado_matricula,
    s.id_semestre,
    s.anio,
    s.periodo,

    -- Hábitos de juego
    h.horario_preferido,
    h.frecuencia_semanal,
    h.impacto_academico,
    h.razon_principal,
    h.juega_antes_examenes,

    -- Sesiones de juego
    sj.id_sesion,
    sj.fecha_sesion,
    sj.hora_inicio,
    sj.hora_fin,
    sj.duracion_minutos,
    sj.tipo_sesion,

    -- Videojuego y plataforma
    v.id_videojuego,
    v.nombre AS nombre_videojuego,
    g.nombre AS genero_videojuego,
    pl.nombre AS plataforma,
    pl.tipo AS tipo_plataforma,

    -- Estadísticas del semestre
    es.total_horas_jugadas,
    es.total_sesiones,
    es.videojuego_mas_jugado,
    es.plataforma_mas_usada

FROM estudiantes e
LEFT JOIN estudiantes_programas ep 
    ON e.id_estudiante = ep.id_estudiante
LEFT JOIN programas_academicos p 
    ON ep.id_programa = p.id_programa
LEFT JOIN semestres s 
    ON ep.id_semestre = s.id_semestre
LEFT JOIN habitos_juego h 
    ON e.id_estudiante = h.id_estudiante AND s.id_semestre = h.id_semestre
LEFT JOIN sesiones_juego sj 
    ON e.id_estudiante = sj.id_estudiante
LEFT JOIN videojuegos v 
    ON sj.id_videojuego = v.id_videojuego
LEFT JOIN generos_juegos g 
    ON v.id_genero = g.id_genero
LEFT JOIN plataformas pl 
    ON sj.id_plataforma = pl.id_plataforma
LEFT JOIN estadisticas_semestre es 
    ON e.id_estudiante = es.id_estudiante AND s.id_semestre = es.id_semestre;

-- Nota:
-- - Se usa LEFT JOIN para no perder registros aunque falte `id_semestre` en estudiantes_programas/sesiones_juego.
-- - Si ya tienes poblada la tabla `semestres` y quieres restringir por período, 
--   puedes filtrar por s.anio/s.periodo desde Looker Studio.
