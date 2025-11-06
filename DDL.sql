-- ==================================================
-- BASE DE DATOS: ESTUDIANTES_VIDEOJUEGOS (Versión Simplificada)
-- ==================================================

-- TABLA: estudiantes
CREATE TABLE estudiantes (
    id_estudiante SERIAL PRIMARY KEY,
    codigo_estudiante VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero VARCHAR(20) NOT NULL
);

-- TABLA: programas_academicos
CREATE TABLE programas_academicos (
    id_programa SERIAL PRIMARY KEY,
    nombre_programa VARCHAR(150) NOT NULL,
    facultad VARCHAR(100) NOT NULL,
    duracion_semestres INT NOT NULL,
    descripcion TEXT
);

-- TABLA: semestres
CREATE TABLE semestres (
    id_semestre SERIAL PRIMARY KEY,
    codigo_semestre VARCHAR(20) NOT NULL,
    anio INT NOT NULL,
    periodo VARCHAR(15) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- TABLA: estudiantes_programas
CREATE TABLE estudiantes_programas (
    id_matricula SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL REFERENCES estudiantes(id_estudiante),
    id_programa INT NOT NULL REFERENCES programas_academicos(id_programa),
    id_semestre INT NOT NULL REFERENCES semestres(id_semestre),
    semestre_cursando INT NOT NULL,
    promedio_acumulado DECIMAL(3,2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    fecha_matricula DATE NOT NULL
);

-- TABLA: plataformas
CREATE TABLE plataformas (
    id_plataforma SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    fabricante VARCHAR(50) NOT NULL
);

-- TABLA: generos_juegos
CREATE TABLE generos_juegos (
    id_genero SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- TABLA: videojuegos
CREATE TABLE videojuegos (
    id_videojuego SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    id_genero INT NOT NULL REFERENCES generos_juegos(id_genero),
    desarrollador VARCHAR(100) NOT NULL,
    anio_lanzamiento INT NOT NULL,
    clasificacion_edad VARCHAR(10) NOT NULL,
    es_multijugador BOOLEAN NOT NULL,
    es_online BOOLEAN NOT NULL,
    descripcion TEXT
);

-- TABLA: videojuegos_plataformas
CREATE TABLE videojuegos_plataformas (
    id_videojuego INT NOT NULL REFERENCES videojuegos(id_videojuego),
    id_plataforma INT NOT NULL REFERENCES plataformas(id_plataforma),
    fecha_lanzamiento DATE NOT NULL,
    PRIMARY KEY (id_videojuego, id_plataforma)
);

-- TABLA: sesiones_juego
CREATE TABLE sesiones_juego (
    id_sesion SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL REFERENCES estudiantes(id_estudiante),
    id_videojuego INT NOT NULL REFERENCES videojuegos(id_videojuego),
    id_plataforma INT NOT NULL REFERENCES plataformas(id_plataforma),
    id_semestre INT NOT NULL REFERENCES semestres(id_semestre),
    fecha_sesion DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    duracion_minutos INT NOT NULL,
    tipo_sesion VARCHAR(30) NOT NULL,
    notas TEXT
);

-- TABLA: resumen_semanal
CREATE TABLE resumen_semanal (
    id_resumen SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL REFERENCES estudiantes(id_estudiante),
    id_semestre INT NOT NULL REFERENCES semestres(id_semestre),
    numero_semana INT NOT NULL,
    fecha_inicio_semana DATE NOT NULL,
    fecha_fin_semana DATE NOT NULL,
    total_minutos_jugados INT NOT NULL,
    total_sesiones INT NOT NULL
);

-- TABLA: estadisticas_semestre
CREATE TABLE estadisticas_semestre (
    id_estadistica SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL REFERENCES estudiantes(id_estudiante),
    id_semestre INT NOT NULL REFERENCES semestres(id_semestre),
    total_horas_jugadas DECIMAL(10,2) NOT NULL,
    total_sesiones INT NOT NULL,
    videojuego_mas_jugado INT NOT NULL REFERENCES videojuegos(id_videojuego),
    plataforma_mas_usada INT NOT NULL REFERENCES plataformas(id_plataforma)
);

-- TABLA: habitos_juego
CREATE TABLE habitos_juego (
    id_habito SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL REFERENCES estudiantes(id_estudiante),
    id_semestre INT NOT NULL REFERENCES semestres(id_semestre),
    horario_preferido VARCHAR(40) NOT NULL,
    frecuencia_semanal VARCHAR(20) NOT NULL,
    impacto_academico VARCHAR(20) NOT NULL,
    razon_principal VARCHAR(200) NOT NULL,
    juega_antes_examenes BOOLEAN NOT NULL
);
