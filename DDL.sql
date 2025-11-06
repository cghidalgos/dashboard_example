-- ==================================================
-- BASE DE DATOS: ESTUDIANTES_VIDEOJUEGOS (Versión Simplificada)
-- ==================================================

-- TABLA: estudiantes
CREATE TABLE estudiantes (
    id_estudiante SERIAL PRIMARY KEY,
    codigo_estudiante VARCHAR(20),
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(150),
    fecha_nacimiento DATE,
    genero VARCHAR(20)
);

-- TABLA: programas_academicos
CREATE TABLE programas_academicos (
    id_programa SERIAL PRIMARY KEY,
    nombre_programa VARCHAR(150),
    facultad VARCHAR(100),
    duracion_semestres INT,
    descripcion TEXT
);

-- TABLA: semestres
CREATE TABLE semestres (
    id_semestre SERIAL PRIMARY KEY,
    codigo_semestre VARCHAR(20),
    anio INT,
    periodo VARCHAR(15),
    fecha_inicio DATE,
    fecha_fin DATE
);

-- TABLA: estudiantes_programas
CREATE TABLE estudiantes_programas (
    id_matricula SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiantes(id_estudiante),
    id_programa INT REFERENCES programas_academicos(id_programa),
    id_semestre INT REFERENCES semestres(id_semestre),
    semestre_cursando INT,
    promedio_acumulado DECIMAL(3,2),
    estado VARCHAR(20),
    fecha_matricula DATE
);

-- TABLA: plataformas
CREATE TABLE plataformas (
    id_plataforma SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(20),
    fabricante VARCHAR(50)
);

-- TABLA: generos_juegos
CREATE TABLE generos_juegos (
    id_genero SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion TEXT
);

-- TABLA: videojuegos
CREATE TABLE videojuegos (
    id_videojuego SERIAL PRIMARY KEY,
    nombre VARCHAR(200),
    id_genero INT REFERENCES generos_juegos(id_genero),
    desarrollador VARCHAR(100),
    anio_lanzamiento INT,
    clasificacion_edad VARCHAR(10),
    es_multijugador BOOLEAN,
    es_online BOOLEAN,
    descripcion TEXT
);

-- TABLA: videojuegos_plataformas
CREATE TABLE videojuegos_plataformas (
    id_videojuego INT REFERENCES videojuegos(id_videojuego),
    id_plataforma INT REFERENCES plataformas(id_plataforma),
    fecha_lanzamiento DATE,
    PRIMARY KEY (id_videojuego, id_plataforma)
);

-- TABLA: sesiones_juego
CREATE TABLE sesiones_juego (
    id_sesion SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiantes(id_estudiante),
    id_videojuego INT REFERENCES videojuegos(id_videojuego),
    id_plataforma INT REFERENCES plataformas(id_plataforma),
    id_semestre INT REFERENCES semestres(id_semestre),
    fecha_sesion DATE,
    hora_inicio TIME,
    hora_fin TIME,
    duracion_minutos INT,
    tipo_sesion VARCHAR(30),
    notas TEXT
);

-- TABLA: resumen_semanal
CREATE TABLE resumen_semanal (
    id_resumen SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiantes(id_estudiante),
    id_semestre INT REFERENCES semestres(id_semestre),
    numero_semana INT,
    fecha_inicio_semana DATE,
    fecha_fin_semana DATE,
    total_minutos_jugados INT,
    total_sesiones INT
);

-- TABLA: estadisticas_semestre
CREATE TABLE estadisticas_semestre (
    id_estadistica SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiantes(id_estudiante),
    id_semestre INT REFERENCES semestres(id_semestre),
    total_horas_jugadas DECIMAL(10,2),
    total_sesiones INT,
    videojuego_mas_jugado INT REFERENCES videojuegos(id_videojuego),
    plataforma_mas_usada INT REFERENCES plataformas(id_plataforma)
);

-- TABLA: habitos_juego
CREATE TABLE habitos_juego (
    id_habito SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiantes(id_estudiante),
    id_semestre INT REFERENCES semestres(id_semestre),
    horario_preferido VARCHAR(40),
    frecuencia_semanal VARCHAR(20),
    impacto_academico VARCHAR(20),
    razon_principal VARCHAR(200),
    juega_antes_examenes BOOLEAN
);
