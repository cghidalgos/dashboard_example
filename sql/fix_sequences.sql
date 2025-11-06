-- Sincroniza las secuencias con el MAX(id) de cada tabla
-- Ejecutar después de cargar DML.sql

SELECT setval('estudiantes_id_estudiante_seq', COALESCE((SELECT MAX(id_estudiante) FROM estudiantes), 1), true);
SELECT setval('programas_academicos_id_programa_seq', COALESCE((SELECT MAX(id_programa) FROM programas_academicos), 1), true);
SELECT setval('semestres_id_semestre_seq', COALESCE((SELECT MAX(id_semestre) FROM semestres), 1), true);
SELECT setval('estudiantes_programas_id_matricula_seq', COALESCE((SELECT MAX(id_matricula) FROM estudiantes_programas), 1), true);
SELECT setval('plataformas_id_plataforma_seq', COALESCE((SELECT MAX(id_plataforma) FROM plataformas), 1), true);
SELECT setval('generos_juegos_id_genero_seq', COALESCE((SELECT MAX(id_genero) FROM generos_juegos), 1), true);
SELECT setval('videojuegos_id_videojuego_seq', COALESCE((SELECT MAX(id_videojuego) FROM videojuegos), 1), true);
SELECT setval('sesiones_juego_id_sesion_seq', COALESCE((SELECT MAX(id_sesion) FROM sesiones_juego), 1), true);
SELECT setval('resumen_semanal_id_resumen_seq', COALESCE((SELECT MAX(id_resumen) FROM resumen_semanal), 1), true);
SELECT setval('estadisticas_semestre_id_estadistica_seq', COALESCE((SELECT MAX(id_estadistica) FROM estadisticas_semestre), 1), true);
SELECT setval('habitos_juego_id_habito_seq', COALESCE((SELECT MAX(id_habito) FROM habitos_juego), 1), true);
