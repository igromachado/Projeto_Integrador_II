DROP DATABASE IF EXISTS db_metalforte;
CREATE DATABASE db_metalforte;
USE db_metalforte;

CREATE TABLE setor (
    id_setor INT PRIMARY KEY AUTO_INCREMENT,
    nome_setor VARCHAR(100) NOT NULL
);

CREATE TABLE fabricante_maquina (
    id_fabricante INT PRIMARY KEY AUTO_INCREMENT,
    nome_fabricante VARCHAR(100) NOT NULL
);

CREATE TABLE maquina (
    id_maquina INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(100) NOT NULL,
    fk_setor INT NOT NULL,
    fk_fabricante INT NOT NULL,

    CONSTRAINT fk_setor_maquina
        FOREIGN KEY (fk_setor)
        REFERENCES setor(id_setor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_fabricante_maquina
        FOREIGN KEY (fk_fabricante)
        REFERENCES fabricante_maquina(id_fabricante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    fk_maquina INT NOT NULL,
    tipo_manutencao VARCHAR(100) NOT NULL,
    data_manutencao DATE NOT NULL,
    custo_manutencao DECIMAL(10,2) NOT NULL,
    causa_falha VARCHAR(200),
    horas_paradas DECIMAL(6,2) NOT NULL,

    CONSTRAINT chk_custo_manutencao
        CHECK (custo_manutencao >= 0),

    CONSTRAINT chk_horas_paradas
        CHECK (horas_paradas >= 0),

    CONSTRAINT fk_maquina_manutencao
        FOREIGN KEY (fk_maquina)
        REFERENCES maquina(id_maquina)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE ordem_servico (
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    fk_manutencao INT NOT NULL,
    data_abertura DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    observacao VARCHAR(255),

    CONSTRAINT uq_ordem_manutencao
        UNIQUE (fk_manutencao),

    CONSTRAINT fk_manutencao_ordem
        FOREIGN KEY (fk_manutencao)
        REFERENCES manutencao(id_manutencao)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE fabricante_peca (
    id_fabricante INT PRIMARY KEY AUTO_INCREMENT,
    nome_fabricante VARCHAR(100) NOT NULL
);

CREATE TABLE peca (
    id_peca INT PRIMARY KEY AUTO_INCREMENT,
    nome_peca VARCHAR(100) NOT NULL,
    fk_fabricante INT NOT NULL,

    CONSTRAINT fk_fabricante_peca
        FOREIGN KEY (fk_fabricante)
        REFERENCES fabricante_peca(id_fabricante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE tecnico (
    id_tecnico INT PRIMARY KEY AUTO_INCREMENT,
    nome_tecnico VARCHAR(100) NOT NULL,
    sobrenome_tecnico VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE ordem_peca (
    id_ordem_peca INT PRIMARY KEY AUTO_INCREMENT,
    fk_ordem INT NOT NULL,
    fk_peca INT NOT NULL,
    quantidade INT NOT NULL,

    CONSTRAINT chk_quantidade_peca
        CHECK (quantidade > 0),

    CONSTRAINT uq_ordem_peca
        UNIQUE (fk_ordem, fk_peca),

    CONSTRAINT fk_ordem_peca
        FOREIGN KEY (fk_ordem)
        REFERENCES ordem_servico(id_ordem)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_peca_ordem
        FOREIGN KEY (fk_peca)
        REFERENCES peca(id_peca)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE ordem_tecnico (
    id_ordem_tecnico INT PRIMARY KEY AUTO_INCREMENT,
    fk_ordem INT NOT NULL,
    fk_tecnico INT NOT NULL,

    CONSTRAINT uq_ordem_tecnico
        UNIQUE (fk_ordem, fk_tecnico),

    CONSTRAINT fk_ordem_tecnico
        FOREIGN KEY (fk_ordem)
        REFERENCES ordem_servico(id_ordem)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_tecnico_ordem
        FOREIGN KEY (fk_tecnico)
        REFERENCES tecnico(id_tecnico)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);