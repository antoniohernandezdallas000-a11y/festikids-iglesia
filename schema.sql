-- ===================================================
-- IGLESIA DE CRISTO EBENEZER - FestiKids
-- Esquema de Base de Datos
-- Versión: 1.0
-- Motor: PostgreSQL / MySQL
-- ===================================================

-- Tabla: contactos_interesados
-- Registra a las personas que se contactan vía WhatsApp
-- o formulario para donar / ser voluntarios en FestiKids
CREATE TABLE IF NOT EXISTS contactos_interesados (
    id              SERIAL PRIMARY KEY,
    nombre          VARCHAR(150),
    telefono        VARCHAR(20)  NOT NULL,
    email           VARCHAR(200),
    mensaje         TEXT,
    tipo_interes    VARCHAR(50)  NOT NULL DEFAULT 'donacion',
                    -- 'donacion', 'voluntariado', 'patrocinio', 'general'
    origen          VARCHAR(50)  DEFAULT 'whatsapp',
                    -- 'whatsapp', 'web_form', 'presencial'
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: transacciones_donaciones
-- Para cuando en el futuro se integre un método de pago
CREATE TABLE IF NOT EXISTS transacciones_donaciones (
    id                  SERIAL PRIMARY KEY,
    contacto_id         INTEGER     REFERENCES contactos_interesados(id),
    monto               DECIMAL(12,2) NOT NULL,
    moneda              VARCHAR(3)  NOT NULL DEFAULT 'VES',
    metodo_pago         VARCHAR(30),
                        -- 'c2p', 'stripe', 'transferencia', 'efectivo', 'otros'
    referencia_pago     VARCHAR(200),
    estado              VARCHAR(20) NOT NULL DEFAULT 'pendiente',
                        -- 'pendiente', 'completado', 'fallido', 'reembolsado'
    notas               TEXT,
    created_at          TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: actividades_festikids
-- Para llevar control de ediciones del evento FestiKids
CREATE TABLE IF NOT EXISTS actividades_festikids (
    id              SERIAL PRIMARY KEY,
    nombre          VARCHAR(200) NOT NULL,
    descripcion     TEXT,
    fecha_evento    DATE,
    meta_recaudacion DECIMAL(12,2),
    monto_recaudado DECIMAL(12,2) DEFAULT 0,
    activo          BOOLEAN      DEFAULT TRUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: patrocinadores
-- Registro de empresas o personas que patrocinan
CREATE TABLE IF NOT EXISTS patrocinadores (
    id              SERIAL PRIMARY KEY,
    nombre          VARCHAR(200) NOT NULL,
    tipo            VARCHAR(30)  DEFAULT 'persona',
                    -- 'persona', 'empresa'
    telefono        VARCHAR(20),
    email           VARCHAR(200),
    logo_url        TEXT,
    sitio_web       TEXT,
    monto_aportado  DECIMAL(12,2) DEFAULT 0,
    agradecimiento_publico BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ===================================================
-- ÍNDICES
-- ===================================================
CREATE INDEX IF NOT EXISTS idx_contactos_telefono   ON contactos_interesados(telefono);
CREATE INDEX IF NOT EXISTS idx_transacciones_estado  ON transacciones_donaciones(estado);
CREATE INDEX IF NOT EXISTS idx_transacciones_contacto ON transacciones_donaciones(contacto_id);
CREATE INDEX IF NOT EXISTS idx_actividades_activo    ON actividades_festikids(activo);
CREATE INDEX IF NOT EXISTS idx_patrocinadores_tipo   ON patrocinadores(tipo);
