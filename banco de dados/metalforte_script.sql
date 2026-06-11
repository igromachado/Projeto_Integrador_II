drop database if exists db_metalforte;
create database db_metalforte;
use db_metalforte;

create table fabricante(
	id_fabricante int primary key auto_increment,
    nome_fabricante varchar(100) not null
);

create table setor(
	id_setor int primary key auto_increment,
    nome_setor varchar(100) not null
);

create table peca(
	id_peca int primary key auto_increment,
    nome_peca varchar(100) not null
);

create table maquina(
	id_maquina int primary key auto_increment,
    modelo_maquina varchar(100) not null,
    fk_setor int not null,
    fk_fabricante int not null,
    
    constraint fk_setor_maquina 
		foreign key(fk_setor) 
        references setor(id_setor)
        on update cascade
        on delete restrict,
	
    constraint fk_fabricante_maquina
		foreign key(fk_fabricante)
        references fabricante(id_fabricante)
        on update cascade
        on delete restrict
);

create table tipo_manutencao(
	id_tipo int primary key auto_increment,
    tipo_manutencao varchar(100) not null
);

create table causa_falha(
	id_causa int primary key auto_increment,
    causa_falha varchar(100) not null
);

create table manutencao(
	id_manutencao int primary key auto_increment,
    fk_maquina int not null,
    data_manutencao date not null,
    custo_manutencao decimal(10,2) not null,
    fk_causa int null,
    fk_tipo int not null,
    horas_parada decimal(6,2) not null,
    
    constraint chk_custo_manutencao
        check (custo_manutencao >= 0),
        
    constraint chk_horas_parada
        check (horas_parada >= 0),
    
    constraint fk_maquina_manutencao
		foreign key(fk_maquina)
        references maquina(id_maquina)
        on update cascade
        on delete restrict,
	
    constraint fk_causa_manutencao
		foreign key(fk_causa)
        references causa_falha(id_causa)
        on update cascade
        on delete restrict,
	
    constraint fk_tipo_manutencao
		foreign key(fk_tipo)
        references tipo_manutencao(id_tipo)
        on update cascade
        on delete restrict
);

create table especialidade_tecnico(
	id_especialidade int primary key auto_increment,
    especialidade varchar(100) not null
);

create table tecnico(
	id_tecnico int primary key auto_increment,
    nome_tecnico varchar(100) not null,
    sobrenome_tecnico varchar(100) not null,
    fk_especialidade int not null,
    
    constraint fk_especialidade_tecnico
		foreign key(fk_especialidade)
        references especialidade_tecnico(id_especialidade)
        on update cascade
        on delete restrict
);

create table ordem_servico(
	id_ordem int primary key auto_increment,
    fk_manutencao int not null,
    data_abertura date not null,
    status_ordem varchar(50) not null,
    observacao varchar(200),
    
    constraint uq_ordem_manutencao
		unique(fk_manutencao),
    
    constraint fk_manutencao_ordem 
		foreign key(fk_manutencao)
        references manutencao(id_manutencao)
        on update cascade
        on delete restrict
);

create table ordem_tecnico(
	id_ordem_tecnico int primary key auto_increment,
    fk_tecnico int not null,
    fk_ordem int not null,
    
    constraint uq_ordem_tecnico
        unique(fk_ordem, fk_tecnico),
    
    constraint fk_tecnico_ordem
		foreign key(fk_tecnico)
        references tecnico(id_tecnico)
        on update cascade
        on delete restrict,
	
    constraint fk_ordem_tecnico
		foreign key(fk_ordem)
        references ordem_servico(id_ordem)
        on update cascade
        on delete cascade
);

create table ordem_peca(
	id_ordem_peca int primary key auto_increment,
    fk_peca int not null,
    fk_ordem int not null,
    quantidade int not null,
    
    constraint chk_quantidade_peca
        check (quantidade > 0),
    
    constraint uq_ordem_peca
        unique(fk_ordem, fk_peca),
    
    constraint fk_peca_ordem
		foreign key(fk_peca)
        references peca(id_peca)
        on update cascade
        on delete restrict,
	
    constraint fk_ordem_peca
		foreign key(fk_ordem)
        references ordem_servico(id_ordem)
        on update cascade
        on delete cascade
);