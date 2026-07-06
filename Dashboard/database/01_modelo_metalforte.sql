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

CREATE TABLE tipo_manutencao(
	id_tipo_manutencao INT PRIMARY KEY AUTO_INCREMENT,
	tipo_manutencao VARCHAR(100) NOT NULL
);

CREATE TABLE causa_falha(
	id_causa_falha INT PRIMARY KEY AUTO_INCREMENT,
	causa_falha VARCHAR(100) NOT NULL
);

CREATE TABLE manutencao(
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    fk_maquina INT NOT NULL,
    fk_tipo_manutencao INT NOT NULL,
    data_manutencao DATE NOT NULL,
    custo_manutencao DECIMAL(10,2) NOT NULL,
    fk_causa_falha INT NOT NULL,
    horas_paradas DECIMAL(6,2) NOT NULL,

    CONSTRAINT chk_custo_manutencao
        CHECK (custo_manutencao >= 0),

    CONSTRAINT chk_horas_paradas
        CHECK (horas_paradas >= 0),

    CONSTRAINT fk_maquina_manutencao
        FOREIGN KEY (fk_maquina)
        REFERENCES maquina(id_maquina)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
  	CONSTRAINT fk_tipo_manutencao
  		FOREIGN KEY (fk_tipo_manutencao)
  		REFERENCES tipo_manutencao(id_tipo_manutencao)
  		ON UPDATE CASCADE
  		ON DELETE CASCADE,
  		
  	CONSTRAINT fk_causa_falha
  		FOREIGN KEY (fk_causa_falha)
  		REFERENCES causa_falha(id_causa_falha)
  		ON UPDATE CASCADE
  		ON DELETE CASCADE
);

CREATE TABLE status_ordem(
	id_status INT PRIMARY KEY AUTO_INCREMENT,
	status_ordem VARCHAR(100) NOT NULL
);

CREATE TABLE ordem_servico(
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    fk_manutencao INT NOT NULL,
    data_abertura DATE NOT NULL,
    fk_status INT NOT NULL,
    observacao VARCHAR(255),

    CONSTRAINT uq_ordem_manutencao
        UNIQUE (fk_manutencao),

	CONSTRAINT fk_status_ordem
		FOREIGN KEY(fk_status)
		REFERENCES status_ordem(id_status)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

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

CREATE TABLE especialidade_tecnico(
	id_especialidade INT PRIMARY KEY AUTO_INCREMENT,
	nome_especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE tecnico (
    id_tecnico INT PRIMARY KEY AUTO_INCREMENT,
    nome_tecnico VARCHAR(100) NOT NULL,
    sobrenome_tecnico VARCHAR(100) NOT NULL,
   	fk_especialidade INT NOT NULL,
   	
   	CONSTRAINT fk_especialidade
   		FOREIGN KEY (fk_especialidade)
   		REFERENCES especialidade_tecnico(id_especialidade)
   		ON UPDATE CASCADE
   		ON DELETE CASCADE
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

insert into tipo_manutencao values 
(1, "Preventiva"),
(default, "Preditiva");

insert into causa_falha values
(1, "Falha Elétrica"),
(default, "Lubrificação"),
(default, "Falha mecânica"),
(default, "Erro operador"),
(default, "Desgaste");

insert into fabricante_peca values
(1, "Bosch"),
(default, "Siemens"),
(default, "WEG"),
(default, "Schneider"),
(default, "Fanuc");

insert into setor values
(1, "Montagem"),
(default, "Usinagem");


insert into especialidade_tecnico values
(1, "Eletricista"),
(default, "Mecânico"),
(default, "Automação");

insert into tecnico values
(1, "Carlos","Silva", 2),
(default, "João","Santos", 2),
(default, "Ana","Costa", 1),
(default, "Fernanda","Alves", 1),
(default, "Lucas","Pereira", 3),
(default, "Marcos","Rocha", 3),
(default, "Rafael","Lima", 2),
(default, "Bruno","Martins", 1),
(default, "Juliana","Ribeiro", 3),
(default, "Gustavo","Fernandes", 2),
(default, "Patricia","Souza", 1),
(default, "Camila","Ferreira", 3);

insert into status_ordem values
(1, "Aberta"),
(default, "Concluída"),
(default, "Em andamento");

insert into fabricante_maquina values
(1, "Romi"),
(default, "Haas"),
(default, "Hidraupress"),
(default, "Newton"),
(default, "Trumpf"),
(default, "Haitian"),
(default, "Kuka"),
(default, "SEW-Eurodrive"),
(default, "Atlas Copco");


 	