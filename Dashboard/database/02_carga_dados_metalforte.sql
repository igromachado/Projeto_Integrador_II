-- Script de carga gerado a partir de Base_final.csv
-- Execute este arquivo DEPOIS de executar o MetalForte.sql em uma base limpa.
-- Este script adiciona campos de rastreabilidade e insere máquinas, peças, manutenções, OS, técnicos e peças usadas.

USE db_metalforte;
SET NAMES utf8mb4;
START TRANSACTION;

-- 1) Campos necessários para preservar os códigos da base CSV
ALTER TABLE maquina ADD COLUMN codigo_maquina VARCHAR(20) NOT NULL UNIQUE AFTER id_maquina;
ALTER TABLE tecnico ADD COLUMN codigo_tecnico VARCHAR(20) NULL UNIQUE AFTER id_tecnico;
ALTER TABLE manutencao ADD COLUMN id_registro_original INT NOT NULL UNIQUE AFTER id_manutencao;
ALTER TABLE ordem_servico ADD COLUMN numero_os VARCHAR(20) NOT NULL UNIQUE AFTER id_ordem;

-- 2) Dado que estava faltando no cadastro original
INSERT INTO tipo_manutencao (tipo_manutencao)
SELECT 'Corretiva'
WHERE NOT EXISTS (SELECT 1 FROM tipo_manutencao WHERE tipo_manutencao = 'Corretiva');

-- 3) Atualiza os códigos dos técnicos já cadastrados no MetalForte.sql
UPDATE tecnico SET codigo_tecnico = 'TEC001' WHERE nome_tecnico = 'Carlos' AND sobrenome_tecnico = 'Silva';
UPDATE tecnico SET codigo_tecnico = 'TEC002' WHERE nome_tecnico = 'João' AND sobrenome_tecnico = 'Santos';
UPDATE tecnico SET codigo_tecnico = 'TEC003' WHERE nome_tecnico = 'Ana' AND sobrenome_tecnico = 'Costa';
UPDATE tecnico SET codigo_tecnico = 'TEC004' WHERE nome_tecnico = 'Fernanda' AND sobrenome_tecnico = 'Alves';
UPDATE tecnico SET codigo_tecnico = 'TEC005' WHERE nome_tecnico = 'Lucas' AND sobrenome_tecnico = 'Pereira';
UPDATE tecnico SET codigo_tecnico = 'TEC006' WHERE nome_tecnico = 'Marcos' AND sobrenome_tecnico = 'Rocha';
UPDATE tecnico SET codigo_tecnico = 'TEC007' WHERE nome_tecnico = 'Rafael' AND sobrenome_tecnico = 'Lima';
UPDATE tecnico SET codigo_tecnico = 'TEC008' WHERE nome_tecnico = 'Bruno' AND sobrenome_tecnico = 'Martins';
UPDATE tecnico SET codigo_tecnico = 'TEC009' WHERE nome_tecnico = 'Juliana' AND sobrenome_tecnico = 'Ribeiro';
UPDATE tecnico SET codigo_tecnico = 'TEC010' WHERE nome_tecnico = 'Gustavo' AND sobrenome_tecnico = 'Fernandes';
UPDATE tecnico SET codigo_tecnico = 'TEC011' WHERE nome_tecnico = 'Patricia' AND sobrenome_tecnico = 'Souza';
UPDATE tecnico SET codigo_tecnico = 'TEC012' WHERE nome_tecnico = 'Camila' AND sobrenome_tecnico = 'Ferreira';
ALTER TABLE tecnico MODIFY COLUMN codigo_tecnico VARCHAR(20) NOT NULL;

-- 4) Máquinas
-- Observação: a base original traz algumas máquinas em mais de um setor.
-- Para respeitar a RN01 do projeto, foi usado o setor mais frequente de cada máquina; em empate, Montagem.
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ001', 'Torno CNC', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Romi'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ001');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ002', 'Fresadora CNC', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Romi'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ002');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ003', 'Centro de Usinagem', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Haas'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ003');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ004', 'Prensa Hidráulica', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Hidraupress'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ004');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ005', 'Dobradeira', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Newton'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ005');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ006', 'Corte Laser', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Trumpf'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ006');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ007', 'Injetora', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Haitian'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ007');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ008', 'Soldadora Robotizada', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Kuka'
WHERE s.nome_setor = 'Montagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ008');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ009', 'Esteira Transportadora', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'SEW-Eurodrive'
WHERE s.nome_setor = 'Montagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ009');
INSERT INTO maquina (codigo_maquina, modelo, fk_setor, fk_fabricante)
SELECT 'MAQ010', 'Compressor Industrial', s.id_setor, fm.id_fabricante
FROM setor s
JOIN fabricante_maquina fm ON fm.nome_fabricante = 'Atlas Copco'
WHERE s.nome_setor = 'Usinagem'
AND NOT EXISTS (SELECT 1 FROM maquina WHERE codigo_maquina = 'MAQ010');

-- 5) Peças utilizadas nas manutenções
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Bomba', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Bomba', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Bomba', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Bomba', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Bomba', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'CLP', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'CLP', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'CLP', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'CLP', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'CLP', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Correia', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Correia', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Correia', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Correia', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Correia', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Filtro', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Filtro', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Filtro', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Filtro', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Filtro', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Motor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Motor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Motor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Motor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Motor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Rolamento', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Rolamento', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Rolamento', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Rolamento', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Rolamento', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Sensor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Sensor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Sensor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Sensor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Sensor', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Válvula', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Bosch'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Válvula', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Fanuc'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Válvula', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Schneider'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Válvula', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'Siemens'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante);
INSERT INTO peca (nome_peca, fk_fabricante)
SELECT 'Válvula', fp.id_fabricante
FROM fabricante_peca fp
WHERE fp.nome_fabricante = 'WEG'
AND NOT EXISTS (SELECT 1 FROM peca p WHERE p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante);

-- 6) Manutenções
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 1, m.id_maquina, tm.id_tipo_manutencao, '2025-04-26', 701.11, cf.id_causa_falha, 17.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 1);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 2, m.id_maquina, tm.id_tipo_manutencao, '2025-02-17', 11805.37, cf.id_causa_falha, 17.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 2);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 3, m.id_maquina, tm.id_tipo_manutencao, '2025-03-02', 9588.87, cf.id_causa_falha, 8.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 3);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 4, m.id_maquina, tm.id_tipo_manutencao, '2025-04-29', 6849.24, cf.id_causa_falha, 3.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 4);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 5, m.id_maquina, tm.id_tipo_manutencao, '2025-06-02', 12967.13, cf.id_causa_falha, 7.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 5);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 6, m.id_maquina, tm.id_tipo_manutencao, '2025-01-02', 3489.14, cf.id_causa_falha, 6.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 6);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 7, m.id_maquina, tm.id_tipo_manutencao, '2025-02-24', 6187.44, cf.id_causa_falha, 14.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 7);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 8, m.id_maquina, tm.id_tipo_manutencao, '2025-05-29', 2551.49, cf.id_causa_falha, 12.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 8);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 9, m.id_maquina, tm.id_tipo_manutencao, '2025-06-04', 4107.68, cf.id_causa_falha, 2.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 9);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 10, m.id_maquina, tm.id_tipo_manutencao, '2025-06-24', 8571.51, cf.id_causa_falha, 2.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 10);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 11, m.id_maquina, tm.id_tipo_manutencao, '2025-05-25', 12110.19, cf.id_causa_falha, 4.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 11);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 12, m.id_maquina, tm.id_tipo_manutencao, '2025-08-02', 8715.27, cf.id_causa_falha, 16.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 12);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 13, m.id_maquina, tm.id_tipo_manutencao, '2025-11-03', 1423.19, cf.id_causa_falha, 8.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 13);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 14, m.id_maquina, tm.id_tipo_manutencao, '2025-04-02', 1974.51, cf.id_causa_falha, 3.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 14);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 15, m.id_maquina, tm.id_tipo_manutencao, '2025-04-01', 1809.70, cf.id_causa_falha, 16.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 15);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 16, m.id_maquina, tm.id_tipo_manutencao, '2025-07-02', 8621.91, cf.id_causa_falha, 6.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 16);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 17, m.id_maquina, tm.id_tipo_manutencao, '2025-01-03', 4634.90, cf.id_causa_falha, 19.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 17);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 18, m.id_maquina, tm.id_tipo_manutencao, '2025-05-09', 4807.29, cf.id_causa_falha, 10.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 18);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 19, m.id_maquina, tm.id_tipo_manutencao, '2025-12-01', 1252.64, cf.id_causa_falha, 16.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 19);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 20, m.id_maquina, tm.id_tipo_manutencao, '2025-06-04', 7618.99, cf.id_causa_falha, 1.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 20);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 21, m.id_maquina, tm.id_tipo_manutencao, '2025-06-05', 8166.03, cf.id_causa_falha, 4.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 21);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 22, m.id_maquina, tm.id_tipo_manutencao, '2025-01-02', 14558.85, cf.id_causa_falha, 18.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 22);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 23, m.id_maquina, tm.id_tipo_manutencao, '2025-05-03', 12373.78, cf.id_causa_falha, 2.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 23);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 24, m.id_maquina, tm.id_tipo_manutencao, '2025-05-12', 7059.37, cf.id_causa_falha, 1.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 24);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 25, m.id_maquina, tm.id_tipo_manutencao, '2025-06-18', 4251.51, cf.id_causa_falha, 13.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 25);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 26, m.id_maquina, tm.id_tipo_manutencao, '2025-06-03', 10425.50, cf.id_causa_falha, 16.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 26);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 27, m.id_maquina, tm.id_tipo_manutencao, '2025-03-15', 13434.61, cf.id_causa_falha, 8.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 27);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 28, m.id_maquina, tm.id_tipo_manutencao, '2025-06-24', 5395.57, cf.id_causa_falha, 5.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 28);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 29, m.id_maquina, tm.id_tipo_manutencao, '2025-02-18', 4436.93, cf.id_causa_falha, 23.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 29);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 30, m.id_maquina, tm.id_tipo_manutencao, '2025-06-13', 6884.45, cf.id_causa_falha, 13.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 30);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 31, m.id_maquina, tm.id_tipo_manutencao, '2025-05-06', 2938.37, cf.id_causa_falha, 13.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 31);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 32, m.id_maquina, tm.id_tipo_manutencao, '2025-06-16', 3515.95, cf.id_causa_falha, 23.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 32);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 33, m.id_maquina, tm.id_tipo_manutencao, '2025-03-15', 3257.71, cf.id_causa_falha, 13.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 33);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 34, m.id_maquina, tm.id_tipo_manutencao, '2025-10-06', 10930.88, cf.id_causa_falha, 4.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 34);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 35, m.id_maquina, tm.id_tipo_manutencao, '2025-10-04', 1862.86, cf.id_causa_falha, 2.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 35);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 36, m.id_maquina, tm.id_tipo_manutencao, '2025-04-13', 7666.07, cf.id_causa_falha, 18.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 36);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 37, m.id_maquina, tm.id_tipo_manutencao, '2025-10-04', 9821.61, cf.id_causa_falha, 14.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 37);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 38, m.id_maquina, tm.id_tipo_manutencao, '2025-06-26', 4009.59, cf.id_causa_falha, 21.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 38);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 39, m.id_maquina, tm.id_tipo_manutencao, '2025-06-29', 3608.40, cf.id_causa_falha, 7.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 39);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 40, m.id_maquina, tm.id_tipo_manutencao, '2025-04-23', 5611.45, cf.id_causa_falha, 14.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 40);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 41, m.id_maquina, tm.id_tipo_manutencao, '2025-05-22', 14413.02, cf.id_causa_falha, 20.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 41);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 42, m.id_maquina, tm.id_tipo_manutencao, '2025-07-04', 10335.53, cf.id_causa_falha, 12.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 42);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 43, m.id_maquina, tm.id_tipo_manutencao, '2025-04-26', 5241.20, cf.id_causa_falha, 4.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 43);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 44, m.id_maquina, tm.id_tipo_manutencao, '2025-05-28', 6596.87, cf.id_causa_falha, 1.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 44);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 45, m.id_maquina, tm.id_tipo_manutencao, '2025-08-06', 2340.63, cf.id_causa_falha, 8.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 45);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 46, m.id_maquina, tm.id_tipo_manutencao, '2025-01-06', 3512.06, cf.id_causa_falha, 15.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 46);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 47, m.id_maquina, tm.id_tipo_manutencao, '2025-05-03', 1477.34, cf.id_causa_falha, 5.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 47);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 48, m.id_maquina, tm.id_tipo_manutencao, '2025-01-05', 4400.13, cf.id_causa_falha, 3.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 48);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 49, m.id_maquina, tm.id_tipo_manutencao, '2025-04-04', 5552.44, cf.id_causa_falha, 12.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 49);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 50, m.id_maquina, tm.id_tipo_manutencao, '2025-04-19', 9990.53, cf.id_causa_falha, 11.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 50);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 51, m.id_maquina, tm.id_tipo_manutencao, '2025-05-03', 4460.38, cf.id_causa_falha, 7.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 51);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 52, m.id_maquina, tm.id_tipo_manutencao, '2025-03-26', 9998.80, cf.id_causa_falha, 7.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 52);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 53, m.id_maquina, tm.id_tipo_manutencao, '2025-06-05', 7357.88, cf.id_causa_falha, 7.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 53);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 54, m.id_maquina, tm.id_tipo_manutencao, '2025-03-01', 4833.40, cf.id_causa_falha, 10.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 54);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 55, m.id_maquina, tm.id_tipo_manutencao, '2025-03-02', 4641.30, cf.id_causa_falha, 4.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 55);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 56, m.id_maquina, tm.id_tipo_manutencao, '2025-04-29', 12128.20, cf.id_causa_falha, 8.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 56);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 57, m.id_maquina, tm.id_tipo_manutencao, '2025-04-06', 7686.74, cf.id_causa_falha, 14.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 57);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 58, m.id_maquina, tm.id_tipo_manutencao, '2025-04-27', 5627.44, cf.id_causa_falha, 4.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 58);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 59, m.id_maquina, tm.id_tipo_manutencao, '2025-02-25', 6892.21, cf.id_causa_falha, 12.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 59);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 60, m.id_maquina, tm.id_tipo_manutencao, '2025-04-05', 10438.56, cf.id_causa_falha, 8.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 60);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 61, m.id_maquina, tm.id_tipo_manutencao, '2025-08-05', 2161.33, cf.id_causa_falha, 16.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 61);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 62, m.id_maquina, tm.id_tipo_manutencao, '2025-04-18', 5538.52, cf.id_causa_falha, 13.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 62);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 63, m.id_maquina, tm.id_tipo_manutencao, '2025-06-25', 13878.93, cf.id_causa_falha, 1.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 63);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 64, m.id_maquina, tm.id_tipo_manutencao, '2025-01-05', 9197.75, cf.id_causa_falha, 2.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 64);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 65, m.id_maquina, tm.id_tipo_manutencao, '2025-11-02', 12667.05, cf.id_causa_falha, 7.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 65);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 66, m.id_maquina, tm.id_tipo_manutencao, '2025-03-04', 5960.37, cf.id_causa_falha, 9.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 66);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 67, m.id_maquina, tm.id_tipo_manutencao, '2025-02-24', 13552.96, cf.id_causa_falha, 8.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 67);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 68, m.id_maquina, tm.id_tipo_manutencao, '2025-01-06', 14649.26, cf.id_causa_falha, 21.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 68);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 69, m.id_maquina, tm.id_tipo_manutencao, '2025-04-09', 8322.14, cf.id_causa_falha, 7.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 69);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 70, m.id_maquina, tm.id_tipo_manutencao, '2025-06-14', 363.73, cf.id_causa_falha, 7.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 70);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 71, m.id_maquina, tm.id_tipo_manutencao, '2025-05-15', 3379.95, cf.id_causa_falha, 2.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 71);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 72, m.id_maquina, tm.id_tipo_manutencao, '2025-03-04', 3344.42, cf.id_causa_falha, 13.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 72);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 73, m.id_maquina, tm.id_tipo_manutencao, '2025-06-19', 3216.20, cf.id_causa_falha, 8.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 73);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 74, m.id_maquina, tm.id_tipo_manutencao, '2025-01-11', 6573.37, cf.id_causa_falha, 4.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 74);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 75, m.id_maquina, tm.id_tipo_manutencao, '2025-11-05', 14966.45, cf.id_causa_falha, 2.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 75);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 76, m.id_maquina, tm.id_tipo_manutencao, '2025-02-21', 10690.74, cf.id_causa_falha, 2.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 76);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 77, m.id_maquina, tm.id_tipo_manutencao, '2025-05-02', 10098.78, cf.id_causa_falha, 13.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 77);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 78, m.id_maquina, tm.id_tipo_manutencao, '2025-02-25', 14046.77, cf.id_causa_falha, 22.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 78);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 79, m.id_maquina, tm.id_tipo_manutencao, '2025-03-16', 7741.66, cf.id_causa_falha, 5.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 79);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 80, m.id_maquina, tm.id_tipo_manutencao, '2025-03-18', 2710.67, cf.id_causa_falha, 18.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 80);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 81, m.id_maquina, tm.id_tipo_manutencao, '2025-03-17', 7113.66, cf.id_causa_falha, 8.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 81);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 82, m.id_maquina, tm.id_tipo_manutencao, '2025-06-24', 4042.06, cf.id_causa_falha, 8.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 82);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 83, m.id_maquina, tm.id_tipo_manutencao, '2025-03-03', 524.08, cf.id_causa_falha, 12.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 83);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 84, m.id_maquina, tm.id_tipo_manutencao, '2025-04-21', 2272.14, cf.id_causa_falha, 8.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 84);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 85, m.id_maquina, tm.id_tipo_manutencao, '2025-12-06', 8225.53, cf.id_causa_falha, 17.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 85);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 86, m.id_maquina, tm.id_tipo_manutencao, '2025-05-06', 12182.36, cf.id_causa_falha, 9.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 86);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 87, m.id_maquina, tm.id_tipo_manutencao, '2025-03-16', 234.81, cf.id_causa_falha, 12.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 87);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 88, m.id_maquina, tm.id_tipo_manutencao, '2025-04-24', 14914.99, cf.id_causa_falha, 19.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 88);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 89, m.id_maquina, tm.id_tipo_manutencao, '2025-06-23', 8169.81, cf.id_causa_falha, 22.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 89);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 90, m.id_maquina, tm.id_tipo_manutencao, '2025-03-30', 14613.71, cf.id_causa_falha, 13.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 90);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 91, m.id_maquina, tm.id_tipo_manutencao, '2025-02-01', 13822.90, cf.id_causa_falha, 22.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 91);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 92, m.id_maquina, tm.id_tipo_manutencao, '2025-01-21', 10070.90, cf.id_causa_falha, 6.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 92);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 93, m.id_maquina, tm.id_tipo_manutencao, '2025-02-01', 6858.46, cf.id_causa_falha, 16.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 93);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 94, m.id_maquina, tm.id_tipo_manutencao, '2025-04-26', 7405.50, cf.id_causa_falha, 12.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 94);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 95, m.id_maquina, tm.id_tipo_manutencao, '2025-03-01', 7496.55, cf.id_causa_falha, 0.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 95);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 96, m.id_maquina, tm.id_tipo_manutencao, '2025-01-22', 4133.76, cf.id_causa_falha, 4.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 96);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 97, m.id_maquina, tm.id_tipo_manutencao, '2025-05-05', 13831.35, cf.id_causa_falha, 5.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 97);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 98, m.id_maquina, tm.id_tipo_manutencao, '2025-06-02', 12367.88, cf.id_causa_falha, 7.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 98);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 99, m.id_maquina, tm.id_tipo_manutencao, '2025-04-07', 14594.16, cf.id_causa_falha, 1.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 99);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 100, m.id_maquina, tm.id_tipo_manutencao, '2025-12-03', 10173.31, cf.id_causa_falha, 6.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 100);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 101, m.id_maquina, tm.id_tipo_manutencao, '2025-03-05', 3246.49, cf.id_causa_falha, 16.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 101);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 102, m.id_maquina, tm.id_tipo_manutencao, '2025-02-16', 10103.94, cf.id_causa_falha, 6.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 102);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 103, m.id_maquina, tm.id_tipo_manutencao, '2025-04-28', 9070.60, cf.id_causa_falha, 22.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 103);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 104, m.id_maquina, tm.id_tipo_manutencao, '2025-02-23', 7406.03, cf.id_causa_falha, 15.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 104);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 105, m.id_maquina, tm.id_tipo_manutencao, '2025-02-14', 8561.79, cf.id_causa_falha, 17.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 105);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 106, m.id_maquina, tm.id_tipo_manutencao, '2025-10-01', 8547.55, cf.id_causa_falha, 21.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 106);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 107, m.id_maquina, tm.id_tipo_manutencao, '2025-04-25', 10733.50, cf.id_causa_falha, 12.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 107);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 108, m.id_maquina, tm.id_tipo_manutencao, '2025-03-13', 11220.27, cf.id_causa_falha, 19.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 108);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 109, m.id_maquina, tm.id_tipo_manutencao, '2025-05-31', 4176.01, cf.id_causa_falha, 13.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 109);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 110, m.id_maquina, tm.id_tipo_manutencao, '2025-02-19', 10826.72, cf.id_causa_falha, 15.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 110);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 111, m.id_maquina, tm.id_tipo_manutencao, '2025-03-05', 6318.65, cf.id_causa_falha, 1.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 111);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 112, m.id_maquina, tm.id_tipo_manutencao, '2025-01-08', 2757.36, cf.id_causa_falha, 19.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 112);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 113, m.id_maquina, tm.id_tipo_manutencao, '2025-01-15', 1225.55, cf.id_causa_falha, 22.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 113);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 114, m.id_maquina, tm.id_tipo_manutencao, '2025-09-06', 5879.02, cf.id_causa_falha, 4.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 114);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 115, m.id_maquina, tm.id_tipo_manutencao, '2025-02-22', 7704.55, cf.id_causa_falha, 1.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 115);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 116, m.id_maquina, tm.id_tipo_manutencao, '2025-05-13', 13406.80, cf.id_causa_falha, 14.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 116);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 117, m.id_maquina, tm.id_tipo_manutencao, '2025-06-01', 3150.07, cf.id_causa_falha, 2.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 117);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 118, m.id_maquina, tm.id_tipo_manutencao, '2025-06-13', 9985.99, cf.id_causa_falha, 13.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 118);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 119, m.id_maquina, tm.id_tipo_manutencao, '2025-05-06', 9925.52, cf.id_causa_falha, 0.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 119);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 120, m.id_maquina, tm.id_tipo_manutencao, '2025-10-03', 3191.53, cf.id_causa_falha, 18.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 120);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 121, m.id_maquina, tm.id_tipo_manutencao, '2025-04-05', 10270.80, cf.id_causa_falha, 10.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 121);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 122, m.id_maquina, tm.id_tipo_manutencao, '2025-05-20', 7096.43, cf.id_causa_falha, 13.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 122);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 123, m.id_maquina, tm.id_tipo_manutencao, '2025-03-15', 7656.92, cf.id_causa_falha, 13.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 123);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 124, m.id_maquina, tm.id_tipo_manutencao, '2025-02-15', 14874.28, cf.id_causa_falha, 3.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 124);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 125, m.id_maquina, tm.id_tipo_manutencao, '2025-05-13', 4389.06, cf.id_causa_falha, 15.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 125);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 126, m.id_maquina, tm.id_tipo_manutencao, '2025-01-02', 9011.87, cf.id_causa_falha, 2.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 126);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 127, m.id_maquina, tm.id_tipo_manutencao, '2025-08-03', 4102.60, cf.id_causa_falha, 10.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 127);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 128, m.id_maquina, tm.id_tipo_manutencao, '2025-04-22', 11818.13, cf.id_causa_falha, 11.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 128);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 129, m.id_maquina, tm.id_tipo_manutencao, '2025-03-15', 8508.79, cf.id_causa_falha, 6.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 129);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 130, m.id_maquina, tm.id_tipo_manutencao, '2025-03-31', 11340.58, cf.id_causa_falha, 19.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 130);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 131, m.id_maquina, tm.id_tipo_manutencao, '2025-03-25', 11152.62, cf.id_causa_falha, 16.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 131);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 132, m.id_maquina, tm.id_tipo_manutencao, '2025-04-24', 14087.06, cf.id_causa_falha, 13.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 132);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 133, m.id_maquina, tm.id_tipo_manutencao, '2025-03-01', 11168.06, cf.id_causa_falha, 3.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 133);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 134, m.id_maquina, tm.id_tipo_manutencao, '2025-03-13', 14894.27, cf.id_causa_falha, 7.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 134);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 135, m.id_maquina, tm.id_tipo_manutencao, '2025-01-18', 1105.66, cf.id_causa_falha, 2.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 135);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 136, m.id_maquina, tm.id_tipo_manutencao, '2025-09-01', 7942.24, cf.id_causa_falha, 9.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 136);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 137, m.id_maquina, tm.id_tipo_manutencao, '2025-04-20', 11857.93, cf.id_causa_falha, 11.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 137);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 138, m.id_maquina, tm.id_tipo_manutencao, '2025-05-22', 11962.77, cf.id_causa_falha, 1.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 138);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 139, m.id_maquina, tm.id_tipo_manutencao, '2025-04-10', 14880.38, cf.id_causa_falha, 20.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 139);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 140, m.id_maquina, tm.id_tipo_manutencao, '2025-02-22', 2157.41, cf.id_causa_falha, 5.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 140);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 141, m.id_maquina, tm.id_tipo_manutencao, '2025-03-09', 1658.91, cf.id_causa_falha, 9.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 141);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 142, m.id_maquina, tm.id_tipo_manutencao, '2025-01-19', 12392.43, cf.id_causa_falha, 20.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 142);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 143, m.id_maquina, tm.id_tipo_manutencao, '2025-06-12', 2541.89, cf.id_causa_falha, 20.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 143);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 144, m.id_maquina, tm.id_tipo_manutencao, '2025-01-29', 13891.43, cf.id_causa_falha, 3.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 144);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 145, m.id_maquina, tm.id_tipo_manutencao, '2025-04-20', 173.38, cf.id_causa_falha, 16.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 145);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 146, m.id_maquina, tm.id_tipo_manutencao, '2025-06-17', 8044.73, cf.id_causa_falha, 20.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 146);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 147, m.id_maquina, tm.id_tipo_manutencao, '2025-03-19', 7239.08, cf.id_causa_falha, 7.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 147);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 148, m.id_maquina, tm.id_tipo_manutencao, '2025-06-29', 13172.02, cf.id_causa_falha, 10.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 148);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 149, m.id_maquina, tm.id_tipo_manutencao, '2025-06-28', 14980.45, cf.id_causa_falha, 0.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 149);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 150, m.id_maquina, tm.id_tipo_manutencao, '2025-02-13', 2353.20, cf.id_causa_falha, 10.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 150);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 151, m.id_maquina, tm.id_tipo_manutencao, '2025-01-04', 1452.29, cf.id_causa_falha, 13.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 151);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 152, m.id_maquina, tm.id_tipo_manutencao, '2025-04-22', 6458.13, cf.id_causa_falha, 4.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 152);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 153, m.id_maquina, tm.id_tipo_manutencao, '2025-06-03', 9034.55, cf.id_causa_falha, 19.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 153);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 154, m.id_maquina, tm.id_tipo_manutencao, '2025-03-04', 11993.44, cf.id_causa_falha, 3.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 154);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 155, m.id_maquina, tm.id_tipo_manutencao, '2025-01-21', 11955.99, cf.id_causa_falha, 2.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 155);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 156, m.id_maquina, tm.id_tipo_manutencao, '2025-03-25', 13669.29, cf.id_causa_falha, 15.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 156);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 157, m.id_maquina, tm.id_tipo_manutencao, '2025-03-05', 14676.74, cf.id_causa_falha, 11.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 157);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 158, m.id_maquina, tm.id_tipo_manutencao, '2025-09-03', 5064.22, cf.id_causa_falha, 10.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 158);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 159, m.id_maquina, tm.id_tipo_manutencao, '2025-04-05', 1238.04, cf.id_causa_falha, 17.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 159);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 160, m.id_maquina, tm.id_tipo_manutencao, '2025-03-29', 13459.02, cf.id_causa_falha, 2.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 160);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 161, m.id_maquina, tm.id_tipo_manutencao, '2025-07-02', 5012.82, cf.id_causa_falha, 11.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 161);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 162, m.id_maquina, tm.id_tipo_manutencao, '2025-02-14', 4197.29, cf.id_causa_falha, 14.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 162);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 163, m.id_maquina, tm.id_tipo_manutencao, '2025-02-28', 3639.91, cf.id_causa_falha, 4.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 163);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 164, m.id_maquina, tm.id_tipo_manutencao, '2025-05-15', 2276.15, cf.id_causa_falha, 8.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 164);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 165, m.id_maquina, tm.id_tipo_manutencao, '2025-05-13', 5273.63, cf.id_causa_falha, 15.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 165);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 166, m.id_maquina, tm.id_tipo_manutencao, '2025-02-22', 4930.64, cf.id_causa_falha, 10.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 166);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 167, m.id_maquina, tm.id_tipo_manutencao, '2025-06-22', 3400.34, cf.id_causa_falha, 21.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 167);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 168, m.id_maquina, tm.id_tipo_manutencao, '2025-05-03', 10823.56, cf.id_causa_falha, 13.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 168);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 169, m.id_maquina, tm.id_tipo_manutencao, '2025-01-02', 2525.99, cf.id_causa_falha, 8.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 169);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 170, m.id_maquina, tm.id_tipo_manutencao, '2025-04-14', 2052.89, cf.id_causa_falha, 23.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 170);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 171, m.id_maquina, tm.id_tipo_manutencao, '2025-07-03', 3537.36, cf.id_causa_falha, 7.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 171);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 172, m.id_maquina, tm.id_tipo_manutencao, '2025-02-13', 9534.50, cf.id_causa_falha, 1.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 172);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 173, m.id_maquina, tm.id_tipo_manutencao, '2025-04-14', 824.42, cf.id_causa_falha, 13.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 173);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 174, m.id_maquina, tm.id_tipo_manutencao, '2025-04-26', 1985.67, cf.id_causa_falha, 1.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 174);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 175, m.id_maquina, tm.id_tipo_manutencao, '2025-03-04', 3787.58, cf.id_causa_falha, 2.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 175);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 176, m.id_maquina, tm.id_tipo_manutencao, '2025-09-02', 7599.04, cf.id_causa_falha, 21.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 176);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 177, m.id_maquina, tm.id_tipo_manutencao, '2025-04-23', 7260.95, cf.id_causa_falha, 16.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 177);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 178, m.id_maquina, tm.id_tipo_manutencao, '2025-01-02', 8761.59, cf.id_causa_falha, 11.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 178);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 179, m.id_maquina, tm.id_tipo_manutencao, '2025-01-12', 5789.62, cf.id_causa_falha, 12.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 179);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 180, m.id_maquina, tm.id_tipo_manutencao, '2025-05-15', 12927.30, cf.id_causa_falha, 16.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 180);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 181, m.id_maquina, tm.id_tipo_manutencao, '2025-04-15', 4787.71, cf.id_causa_falha, 9.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 181);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 182, m.id_maquina, tm.id_tipo_manutencao, '2025-02-19', 8916.78, cf.id_causa_falha, 14.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 182);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 183, m.id_maquina, tm.id_tipo_manutencao, '2025-05-29', 143.52, cf.id_causa_falha, 18.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 183);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 184, m.id_maquina, tm.id_tipo_manutencao, '2025-01-31', 7110.91, cf.id_causa_falha, 18.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 184);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 185, m.id_maquina, tm.id_tipo_manutencao, '2025-05-14', 4353.11, cf.id_causa_falha, 2.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 185);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 186, m.id_maquina, tm.id_tipo_manutencao, '2025-01-21', 452.43, cf.id_causa_falha, 15.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 186);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 187, m.id_maquina, tm.id_tipo_manutencao, '2025-06-30', 6911.10, cf.id_causa_falha, 7.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 187);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 188, m.id_maquina, tm.id_tipo_manutencao, '2025-10-06', 1538.00, cf.id_causa_falha, 19.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 188);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 189, m.id_maquina, tm.id_tipo_manutencao, '2025-06-03', 9886.12, cf.id_causa_falha, 17.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 189);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 190, m.id_maquina, tm.id_tipo_manutencao, '2025-06-06', 7311.92, cf.id_causa_falha, 12.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 190);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 191, m.id_maquina, tm.id_tipo_manutencao, '2025-05-29', 8451.71, cf.id_causa_falha, 16.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 191);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 192, m.id_maquina, tm.id_tipo_manutencao, '2025-06-27', 12903.36, cf.id_causa_falha, 21.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 192);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 193, m.id_maquina, tm.id_tipo_manutencao, '2025-01-01', 6740.82, cf.id_causa_falha, 20.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 193);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 194, m.id_maquina, tm.id_tipo_manutencao, '2025-01-01', 696.70, cf.id_causa_falha, 23.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 194);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 195, m.id_maquina, tm.id_tipo_manutencao, '2025-05-19', 10110.26, cf.id_causa_falha, 3.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 195);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 196, m.id_maquina, tm.id_tipo_manutencao, '2025-06-18', 8908.73, cf.id_causa_falha, 22.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 196);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 197, m.id_maquina, tm.id_tipo_manutencao, '2025-01-23', 13290.80, cf.id_causa_falha, 19.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 197);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 198, m.id_maquina, tm.id_tipo_manutencao, '2025-06-29', 12193.66, cf.id_causa_falha, 2.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 198);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 199, m.id_maquina, tm.id_tipo_manutencao, '2025-09-01', 7768.05, cf.id_causa_falha, 7.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 199);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 200, m.id_maquina, tm.id_tipo_manutencao, '2025-02-13', 6278.98, cf.id_causa_falha, 17.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 200);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 201, m.id_maquina, tm.id_tipo_manutencao, '2025-02-20', 13984.27, cf.id_causa_falha, 7.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 201);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 202, m.id_maquina, tm.id_tipo_manutencao, '2025-03-06', 10504.89, cf.id_causa_falha, 7.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 202);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 203, m.id_maquina, tm.id_tipo_manutencao, '2025-06-19', 3898.09, cf.id_causa_falha, 0.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 203);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 204, m.id_maquina, tm.id_tipo_manutencao, '2025-03-23', 5921.89, cf.id_causa_falha, 15.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 204);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 205, m.id_maquina, tm.id_tipo_manutencao, '2025-03-08', 12882.07, cf.id_causa_falha, 20.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 205);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 206, m.id_maquina, tm.id_tipo_manutencao, '2025-11-03', 5498.34, cf.id_causa_falha, 18.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 206);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 207, m.id_maquina, tm.id_tipo_manutencao, '2025-04-21', 343.27, cf.id_causa_falha, 22.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 207);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 208, m.id_maquina, tm.id_tipo_manutencao, '2025-01-30', 3322.56, cf.id_causa_falha, 20.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 208);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 209, m.id_maquina, tm.id_tipo_manutencao, '2025-07-06', 7877.69, cf.id_causa_falha, 14.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 209);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 210, m.id_maquina, tm.id_tipo_manutencao, '2025-01-06', 2749.49, cf.id_causa_falha, 6.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 210);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 211, m.id_maquina, tm.id_tipo_manutencao, '2025-07-01', 4516.08, cf.id_causa_falha, 22.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 211);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 212, m.id_maquina, tm.id_tipo_manutencao, '2025-01-18', 10151.96, cf.id_causa_falha, 6.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 212);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 213, m.id_maquina, tm.id_tipo_manutencao, '2025-03-31', 11125.47, cf.id_causa_falha, 0.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 213);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 214, m.id_maquina, tm.id_tipo_manutencao, '2025-05-06', 1474.42, cf.id_causa_falha, 5.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 214);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 215, m.id_maquina, tm.id_tipo_manutencao, '2025-01-18', 13010.65, cf.id_causa_falha, 19.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 215);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 216, m.id_maquina, tm.id_tipo_manutencao, '2025-04-16', 14838.59, cf.id_causa_falha, 3.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 216);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 217, m.id_maquina, tm.id_tipo_manutencao, '2025-09-02', 4294.69, cf.id_causa_falha, 22.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 217);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 218, m.id_maquina, tm.id_tipo_manutencao, '2025-02-06', 13849.11, cf.id_causa_falha, 13.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 218);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 219, m.id_maquina, tm.id_tipo_manutencao, '2025-09-02', 900.49, cf.id_causa_falha, 9.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 219);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 220, m.id_maquina, tm.id_tipo_manutencao, '2025-01-02', 12866.55, cf.id_causa_falha, 3.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 220);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 221, m.id_maquina, tm.id_tipo_manutencao, '2025-12-04', 5975.34, cf.id_causa_falha, 15.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 221);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 222, m.id_maquina, tm.id_tipo_manutencao, '2025-04-13', 8773.70, cf.id_causa_falha, 14.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 222);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 223, m.id_maquina, tm.id_tipo_manutencao, '2025-02-21', 13779.49, cf.id_causa_falha, 7.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 223);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 224, m.id_maquina, tm.id_tipo_manutencao, '2025-05-17', 14505.87, cf.id_causa_falha, 21.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 224);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 225, m.id_maquina, tm.id_tipo_manutencao, '2025-03-18', 13763.21, cf.id_causa_falha, 1.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 225);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 226, m.id_maquina, tm.id_tipo_manutencao, '2025-03-17', 5752.07, cf.id_causa_falha, 22.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 226);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 227, m.id_maquina, tm.id_tipo_manutencao, '2025-05-04', 12080.38, cf.id_causa_falha, 18.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 227);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 228, m.id_maquina, tm.id_tipo_manutencao, '2025-04-03', 3321.45, cf.id_causa_falha, 22.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 228);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 229, m.id_maquina, tm.id_tipo_manutencao, '2025-05-15', 493.84, cf.id_causa_falha, 10.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 229);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 230, m.id_maquina, tm.id_tipo_manutencao, '2025-04-03', 672.70, cf.id_causa_falha, 14.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 230);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 231, m.id_maquina, tm.id_tipo_manutencao, '2025-04-24', 7099.98, cf.id_causa_falha, 6.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 231);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 232, m.id_maquina, tm.id_tipo_manutencao, '2025-06-24', 5759.30, cf.id_causa_falha, 1.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 232);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 233, m.id_maquina, tm.id_tipo_manutencao, '2025-03-13', 12567.85, cf.id_causa_falha, 12.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 233);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 234, m.id_maquina, tm.id_tipo_manutencao, '2025-01-20', 175.53, cf.id_causa_falha, 15.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 234);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 235, m.id_maquina, tm.id_tipo_manutencao, '2025-04-06', 10724.28, cf.id_causa_falha, 3.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 235);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 236, m.id_maquina, tm.id_tipo_manutencao, '2025-05-24', 10924.59, cf.id_causa_falha, 23.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 236);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 237, m.id_maquina, tm.id_tipo_manutencao, '2025-01-28', 2970.56, cf.id_causa_falha, 8.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 237);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 238, m.id_maquina, tm.id_tipo_manutencao, '2025-04-04', 13933.78, cf.id_causa_falha, 13.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 238);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 239, m.id_maquina, tm.id_tipo_manutencao, '2025-05-08', 1253.75, cf.id_causa_falha, 9.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 239);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 240, m.id_maquina, tm.id_tipo_manutencao, '2025-01-15', 1872.32, cf.id_causa_falha, 13.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 240);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 241, m.id_maquina, tm.id_tipo_manutencao, '2025-02-13', 4578.19, cf.id_causa_falha, 20.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 241);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 242, m.id_maquina, tm.id_tipo_manutencao, '2025-08-03', 6339.25, cf.id_causa_falha, 7.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 242);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 243, m.id_maquina, tm.id_tipo_manutencao, '2025-04-06', 4171.39, cf.id_causa_falha, 9.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 243);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 244, m.id_maquina, tm.id_tipo_manutencao, '2025-06-04', 6435.77, cf.id_causa_falha, 1.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 244);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 245, m.id_maquina, tm.id_tipo_manutencao, '2025-06-02', 1995.86, cf.id_causa_falha, 17.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 245);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 246, m.id_maquina, tm.id_tipo_manutencao, '2025-06-24', 3120.74, cf.id_causa_falha, 13.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 246);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 247, m.id_maquina, tm.id_tipo_manutencao, '2025-08-06', 10836.58, cf.id_causa_falha, 0.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 247);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 248, m.id_maquina, tm.id_tipo_manutencao, '2025-03-05', 9769.08, cf.id_causa_falha, 5.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 248);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 249, m.id_maquina, tm.id_tipo_manutencao, '2025-01-21', 7510.35, cf.id_causa_falha, 3.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 249);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 250, m.id_maquina, tm.id_tipo_manutencao, '2025-03-20', 8403.04, cf.id_causa_falha, 23.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 250);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 251, m.id_maquina, tm.id_tipo_manutencao, '2025-04-23', 5671.84, cf.id_causa_falha, 12.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 251);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 252, m.id_maquina, tm.id_tipo_manutencao, '2025-02-10', 7509.40, cf.id_causa_falha, 5.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 252);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 253, m.id_maquina, tm.id_tipo_manutencao, '2025-09-02', 7314.39, cf.id_causa_falha, 9.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 253);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 254, m.id_maquina, tm.id_tipo_manutencao, '2025-11-03', 11265.77, cf.id_causa_falha, 7.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 254);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 255, m.id_maquina, tm.id_tipo_manutencao, '2025-02-19', 14104.57, cf.id_causa_falha, 2.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 255);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 256, m.id_maquina, tm.id_tipo_manutencao, '2025-04-03', 1496.09, cf.id_causa_falha, 13.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 256);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 257, m.id_maquina, tm.id_tipo_manutencao, '2025-02-27', 12116.98, cf.id_causa_falha, 5.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 257);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 258, m.id_maquina, tm.id_tipo_manutencao, '2025-05-22', 5476.79, cf.id_causa_falha, 4.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 258);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 259, m.id_maquina, tm.id_tipo_manutencao, '2025-02-28', 14107.66, cf.id_causa_falha, 2.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 259);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 260, m.id_maquina, tm.id_tipo_manutencao, '2025-01-25', 10812.95, cf.id_causa_falha, 15.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 260);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 261, m.id_maquina, tm.id_tipo_manutencao, '2025-04-13', 13050.24, cf.id_causa_falha, 11.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 261);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 262, m.id_maquina, tm.id_tipo_manutencao, '2025-09-04', 14345.46, cf.id_causa_falha, 0.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 262);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 263, m.id_maquina, tm.id_tipo_manutencao, '2025-04-12', 11511.34, cf.id_causa_falha, 13.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 263);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 264, m.id_maquina, tm.id_tipo_manutencao, '2025-06-20', 7464.31, cf.id_causa_falha, 22.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 264);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 265, m.id_maquina, tm.id_tipo_manutencao, '2025-11-02', 1826.82, cf.id_causa_falha, 8.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 265);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 266, m.id_maquina, tm.id_tipo_manutencao, '2025-01-03', 7097.26, cf.id_causa_falha, 22.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 266);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 267, m.id_maquina, tm.id_tipo_manutencao, '2025-04-06', 1980.48, cf.id_causa_falha, 5.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 267);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 268, m.id_maquina, tm.id_tipo_manutencao, '2025-01-22', 3011.83, cf.id_causa_falha, 15.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 268);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 269, m.id_maquina, tm.id_tipo_manutencao, '2025-03-13', 14899.80, cf.id_causa_falha, 15.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 269);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 270, m.id_maquina, tm.id_tipo_manutencao, '2025-02-20', 9413.92, cf.id_causa_falha, 9.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 270);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 271, m.id_maquina, tm.id_tipo_manutencao, '2025-05-26', 6791.62, cf.id_causa_falha, 1.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 271);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 272, m.id_maquina, tm.id_tipo_manutencao, '2025-05-01', 4828.81, cf.id_causa_falha, 12.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 272);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 273, m.id_maquina, tm.id_tipo_manutencao, '2025-05-22', 13184.94, cf.id_causa_falha, 7.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 273);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 274, m.id_maquina, tm.id_tipo_manutencao, '2025-06-13', 4696.16, cf.id_causa_falha, 23.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 274);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 275, m.id_maquina, tm.id_tipo_manutencao, '2025-05-21', 8199.26, cf.id_causa_falha, 17.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 275);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 276, m.id_maquina, tm.id_tipo_manutencao, '2025-01-02', 12559.31, cf.id_causa_falha, 13.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 276);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 277, m.id_maquina, tm.id_tipo_manutencao, '2025-06-01', 8447.67, cf.id_causa_falha, 4.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 277);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 278, m.id_maquina, tm.id_tipo_manutencao, '2025-04-17', 14314.72, cf.id_causa_falha, 8.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 278);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 279, m.id_maquina, tm.id_tipo_manutencao, '2025-06-03', 10046.36, cf.id_causa_falha, 21.80
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 279);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 280, m.id_maquina, tm.id_tipo_manutencao, '2025-06-02', 2375.62, cf.id_causa_falha, 23.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 280);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 281, m.id_maquina, tm.id_tipo_manutencao, '2025-06-01', 13683.27, cf.id_causa_falha, 9.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 281);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 282, m.id_maquina, tm.id_tipo_manutencao, '2025-04-28', 506.70, cf.id_causa_falha, 16.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ004'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 282);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 283, m.id_maquina, tm.id_tipo_manutencao, '2025-06-22', 6725.45, cf.id_causa_falha, 6.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 283);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 284, m.id_maquina, tm.id_tipo_manutencao, '2025-10-05', 10485.58, cf.id_causa_falha, 20.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 284);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 285, m.id_maquina, tm.id_tipo_manutencao, '2025-04-17', 4056.30, cf.id_causa_falha, 22.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 285);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 286, m.id_maquina, tm.id_tipo_manutencao, '2025-01-27', 1390.88, cf.id_causa_falha, 20.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ009'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 286);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 287, m.id_maquina, tm.id_tipo_manutencao, '2025-01-17', 4290.23, cf.id_causa_falha, 2.40
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 287);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 288, m.id_maquina, tm.id_tipo_manutencao, '2025-03-05', 8728.47, cf.id_causa_falha, 9.90
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 288);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 289, m.id_maquina, tm.id_tipo_manutencao, '2025-03-20', 3355.40, cf.id_causa_falha, 23.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 289);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 290, m.id_maquina, tm.id_tipo_manutencao, '2025-02-21', 14883.79, cf.id_causa_falha, 23.00
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ007'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 290);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 291, m.id_maquina, tm.id_tipo_manutencao, '2025-04-24', 6372.06, cf.id_causa_falha, 9.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha mecânica'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 291);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 292, m.id_maquina, tm.id_tipo_manutencao, '2025-06-23', 13028.55, cf.id_causa_falha, 22.70
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 292);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 293, m.id_maquina, tm.id_tipo_manutencao, '2025-01-27', 1654.46, cf.id_causa_falha, 9.30
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ008'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 293);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 294, m.id_maquina, tm.id_tipo_manutencao, '2025-04-18', 2086.68, cf.id_causa_falha, 10.10
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Erro operador'
WHERE m.codigo_maquina = 'MAQ005'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 294);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 295, m.id_maquina, tm.id_tipo_manutencao, '2025-04-04', 6358.86, cf.id_causa_falha, 4.60
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preditiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ003'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 295);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 296, m.id_maquina, tm.id_tipo_manutencao, '2025-01-03', 5389.72, cf.id_causa_falha, 4.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ002'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 296);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 297, m.id_maquina, tm.id_tipo_manutencao, '2025-01-13', 7589.60, cf.id_causa_falha, 16.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 297);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 298, m.id_maquina, tm.id_tipo_manutencao, '2025-01-16', 5692.44, cf.id_causa_falha, 1.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Desgaste'
WHERE m.codigo_maquina = 'MAQ001'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 298);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 299, m.id_maquina, tm.id_tipo_manutencao, '2025-02-10', 1756.09, cf.id_causa_falha, 8.50
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Corretiva'
JOIN causa_falha cf ON cf.causa_falha = 'Lubrificação'
WHERE m.codigo_maquina = 'MAQ006'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 299);
INSERT INTO manutencao (id_registro_original, fk_maquina, fk_tipo_manutencao, data_manutencao, custo_manutencao, fk_causa_falha, horas_paradas)
SELECT 300, m.id_maquina, tm.id_tipo_manutencao, '2025-05-21', 4779.24, cf.id_causa_falha, 12.20
FROM maquina m
JOIN tipo_manutencao tm ON tm.tipo_manutencao = 'Preventiva'
JOIN causa_falha cf ON cf.causa_falha = 'Falha Elétrica'
WHERE m.codigo_maquina = 'MAQ010'
AND NOT EXISTS (SELECT 1 FROM manutencao WHERE id_registro_original = 300);

-- 7) Ordens de serviço
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1001', man.id_manutencao, '2025-04-26', st.id_status, 'Importado da Base_final.csv - Registro 1'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 1
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1001');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1002', man.id_manutencao, '2025-02-17', st.id_status, 'Importado da Base_final.csv - Registro 2'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 2
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1002');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1003', man.id_manutencao, '2025-03-02', st.id_status, 'Importado da Base_final.csv - Registro 3'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 3
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1003');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1004', man.id_manutencao, '2025-04-29', st.id_status, 'Importado da Base_final.csv - Registro 4'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 4
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1004');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1005', man.id_manutencao, '2025-06-02', st.id_status, 'Importado da Base_final.csv - Registro 5'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 5
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1005');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1006', man.id_manutencao, '2025-01-02', st.id_status, 'Importado da Base_final.csv - Registro 6'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 6
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1006');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1007', man.id_manutencao, '2025-02-24', st.id_status, 'Importado da Base_final.csv - Registro 7'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 7
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1007');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1008', man.id_manutencao, '2025-05-29', st.id_status, 'Importado da Base_final.csv - Registro 8'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 8
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1008');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1009', man.id_manutencao, '2025-06-04', st.id_status, 'Importado da Base_final.csv - Registro 9'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 9
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1009');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1010', man.id_manutencao, '2025-06-24', st.id_status, 'Importado da Base_final.csv - Registro 10'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 10
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1010');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1011', man.id_manutencao, '2025-05-25', st.id_status, 'Importado da Base_final.csv - Registro 11'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 11
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1011');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1012', man.id_manutencao, '2025-08-02', st.id_status, 'Importado da Base_final.csv - Registro 12'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 12
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1012');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1013', man.id_manutencao, '2025-11-03', st.id_status, 'Importado da Base_final.csv - Registro 13'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 13
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1013');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1014', man.id_manutencao, '2025-04-02', st.id_status, 'Importado da Base_final.csv - Registro 14'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 14
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1014');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1015', man.id_manutencao, '2025-04-01', st.id_status, 'Importado da Base_final.csv - Registro 15'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 15
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1015');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1016', man.id_manutencao, '2025-07-02', st.id_status, 'Importado da Base_final.csv - Registro 16'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 16
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1016');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1017', man.id_manutencao, '2025-01-03', st.id_status, 'Importado da Base_final.csv - Registro 17'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 17
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1017');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1018', man.id_manutencao, '2025-05-09', st.id_status, 'Importado da Base_final.csv - Registro 18'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 18
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1018');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1019', man.id_manutencao, '2025-12-01', st.id_status, 'Importado da Base_final.csv - Registro 19'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 19
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1019');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1020', man.id_manutencao, '2025-06-04', st.id_status, 'Importado da Base_final.csv - Registro 20'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 20
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1020');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1021', man.id_manutencao, '2025-06-05', st.id_status, 'Importado da Base_final.csv - Registro 21'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 21
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1021');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1022', man.id_manutencao, '2025-01-02', st.id_status, 'Importado da Base_final.csv - Registro 22'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 22
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1022');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1023', man.id_manutencao, '2025-05-03', st.id_status, 'Importado da Base_final.csv - Registro 23'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 23
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1023');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1024', man.id_manutencao, '2025-05-12', st.id_status, 'Importado da Base_final.csv - Registro 24'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 24
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1024');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1025', man.id_manutencao, '2025-06-18', st.id_status, 'Importado da Base_final.csv - Registro 25'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 25
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1025');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1026', man.id_manutencao, '2025-06-03', st.id_status, 'Importado da Base_final.csv - Registro 26'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 26
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1026');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1027', man.id_manutencao, '2025-03-15', st.id_status, 'Importado da Base_final.csv - Registro 27'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 27
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1027');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1028', man.id_manutencao, '2025-06-24', st.id_status, 'Importado da Base_final.csv - Registro 28'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 28
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1028');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1029', man.id_manutencao, '2025-02-18', st.id_status, 'Importado da Base_final.csv - Registro 29'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 29
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1029');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1030', man.id_manutencao, '2025-06-13', st.id_status, 'Importado da Base_final.csv - Registro 30'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 30
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1030');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1031', man.id_manutencao, '2025-05-06', st.id_status, 'Importado da Base_final.csv - Registro 31'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 31
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1031');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1032', man.id_manutencao, '2025-06-16', st.id_status, 'Importado da Base_final.csv - Registro 32'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 32
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1032');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1033', man.id_manutencao, '2025-03-15', st.id_status, 'Importado da Base_final.csv - Registro 33'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 33
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1033');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1034', man.id_manutencao, '2025-10-06', st.id_status, 'Importado da Base_final.csv - Registro 34'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 34
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1034');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1035', man.id_manutencao, '2025-10-04', st.id_status, 'Importado da Base_final.csv - Registro 35'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 35
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1035');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1036', man.id_manutencao, '2025-04-13', st.id_status, 'Importado da Base_final.csv - Registro 36'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 36
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1036');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1037', man.id_manutencao, '2025-10-04', st.id_status, 'Importado da Base_final.csv - Registro 37'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 37
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1037');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1038', man.id_manutencao, '2025-06-26', st.id_status, 'Importado da Base_final.csv - Registro 38'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 38
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1038');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1039', man.id_manutencao, '2025-06-29', st.id_status, 'Importado da Base_final.csv - Registro 39'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 39
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1039');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1040', man.id_manutencao, '2025-04-23', st.id_status, 'Importado da Base_final.csv - Registro 40'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 40
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1040');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1041', man.id_manutencao, '2025-05-22', st.id_status, 'Importado da Base_final.csv - Registro 41'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 41
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1041');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1042', man.id_manutencao, '2025-07-04', st.id_status, 'Importado da Base_final.csv - Registro 42'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 42
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1042');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1043', man.id_manutencao, '2025-04-26', st.id_status, 'Importado da Base_final.csv - Registro 43'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 43
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1043');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1044', man.id_manutencao, '2025-05-28', st.id_status, 'Importado da Base_final.csv - Registro 44'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 44
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1044');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1045', man.id_manutencao, '2025-08-06', st.id_status, 'Importado da Base_final.csv - Registro 45'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 45
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1045');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1046', man.id_manutencao, '2025-01-06', st.id_status, 'Importado da Base_final.csv - Registro 46'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 46
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1046');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1047', man.id_manutencao, '2025-05-03', st.id_status, 'Importado da Base_final.csv - Registro 47'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 47
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1047');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1048', man.id_manutencao, '2025-01-05', st.id_status, 'Importado da Base_final.csv - Registro 48'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 48
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1048');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1049', man.id_manutencao, '2025-04-04', st.id_status, 'Importado da Base_final.csv - Registro 49'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 49
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1049');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1050', man.id_manutencao, '2025-04-19', st.id_status, 'Importado da Base_final.csv - Registro 50'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 50
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1050');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1051', man.id_manutencao, '2025-05-03', st.id_status, 'Importado da Base_final.csv - Registro 51'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 51
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1051');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1052', man.id_manutencao, '2025-03-26', st.id_status, 'Importado da Base_final.csv - Registro 52'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 52
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1052');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1053', man.id_manutencao, '2025-06-05', st.id_status, 'Importado da Base_final.csv - Registro 53'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 53
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1053');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1054', man.id_manutencao, '2025-03-01', st.id_status, 'Importado da Base_final.csv - Registro 54'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 54
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1054');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1055', man.id_manutencao, '2025-03-02', st.id_status, 'Importado da Base_final.csv - Registro 55'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 55
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1055');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1056', man.id_manutencao, '2025-04-29', st.id_status, 'Importado da Base_final.csv - Registro 56'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 56
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1056');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1057', man.id_manutencao, '2025-04-06', st.id_status, 'Importado da Base_final.csv - Registro 57'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 57
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1057');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1058', man.id_manutencao, '2025-04-27', st.id_status, 'Importado da Base_final.csv - Registro 58'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 58
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1058');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1059', man.id_manutencao, '2025-02-25', st.id_status, 'Importado da Base_final.csv - Registro 59'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 59
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1059');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1060', man.id_manutencao, '2025-04-05', st.id_status, 'Importado da Base_final.csv - Registro 60'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 60
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1060');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1061', man.id_manutencao, '2025-08-05', st.id_status, 'Importado da Base_final.csv - Registro 61'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 61
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1061');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1062', man.id_manutencao, '2025-04-18', st.id_status, 'Importado da Base_final.csv - Registro 62'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 62
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1062');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1063', man.id_manutencao, '2025-06-25', st.id_status, 'Importado da Base_final.csv - Registro 63'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 63
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1063');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1064', man.id_manutencao, '2025-01-05', st.id_status, 'Importado da Base_final.csv - Registro 64'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 64
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1064');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1065', man.id_manutencao, '2025-11-02', st.id_status, 'Importado da Base_final.csv - Registro 65'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 65
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1065');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1066', man.id_manutencao, '2025-03-04', st.id_status, 'Importado da Base_final.csv - Registro 66'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 66
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1066');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1067', man.id_manutencao, '2025-02-24', st.id_status, 'Importado da Base_final.csv - Registro 67'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 67
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1067');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1068', man.id_manutencao, '2025-01-06', st.id_status, 'Importado da Base_final.csv - Registro 68'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 68
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1068');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1069', man.id_manutencao, '2025-04-09', st.id_status, 'Importado da Base_final.csv - Registro 69'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 69
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1069');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1070', man.id_manutencao, '2025-06-14', st.id_status, 'Importado da Base_final.csv - Registro 70'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 70
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1070');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1071', man.id_manutencao, '2025-05-15', st.id_status, 'Importado da Base_final.csv - Registro 71'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 71
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1071');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1072', man.id_manutencao, '2025-03-04', st.id_status, 'Importado da Base_final.csv - Registro 72'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 72
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1072');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1073', man.id_manutencao, '2025-06-19', st.id_status, 'Importado da Base_final.csv - Registro 73'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 73
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1073');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1074', man.id_manutencao, '2025-01-11', st.id_status, 'Importado da Base_final.csv - Registro 74'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 74
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1074');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1075', man.id_manutencao, '2025-11-05', st.id_status, 'Importado da Base_final.csv - Registro 75'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 75
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1075');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1076', man.id_manutencao, '2025-02-21', st.id_status, 'Importado da Base_final.csv - Registro 76'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 76
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1076');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1077', man.id_manutencao, '2025-05-02', st.id_status, 'Importado da Base_final.csv - Registro 77'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 77
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1077');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1078', man.id_manutencao, '2025-02-25', st.id_status, 'Importado da Base_final.csv - Registro 78'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 78
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1078');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1079', man.id_manutencao, '2025-03-16', st.id_status, 'Importado da Base_final.csv - Registro 79'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 79
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1079');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1080', man.id_manutencao, '2025-03-18', st.id_status, 'Importado da Base_final.csv - Registro 80'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 80
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1080');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1081', man.id_manutencao, '2025-03-17', st.id_status, 'Importado da Base_final.csv - Registro 81'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 81
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1081');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1082', man.id_manutencao, '2025-06-24', st.id_status, 'Importado da Base_final.csv - Registro 82'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 82
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1082');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1083', man.id_manutencao, '2025-03-03', st.id_status, 'Importado da Base_final.csv - Registro 83'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 83
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1083');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1084', man.id_manutencao, '2025-04-21', st.id_status, 'Importado da Base_final.csv - Registro 84'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 84
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1084');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1085', man.id_manutencao, '2025-12-06', st.id_status, 'Importado da Base_final.csv - Registro 85'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 85
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1085');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1086', man.id_manutencao, '2025-05-06', st.id_status, 'Importado da Base_final.csv - Registro 86'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 86
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1086');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1087', man.id_manutencao, '2025-03-16', st.id_status, 'Importado da Base_final.csv - Registro 87'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 87
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1087');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1088', man.id_manutencao, '2025-04-24', st.id_status, 'Importado da Base_final.csv - Registro 88'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 88
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1088');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1089', man.id_manutencao, '2025-06-23', st.id_status, 'Importado da Base_final.csv - Registro 89'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 89
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1089');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1090', man.id_manutencao, '2025-03-30', st.id_status, 'Importado da Base_final.csv - Registro 90'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 90
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1090');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1091', man.id_manutencao, '2025-02-01', st.id_status, 'Importado da Base_final.csv - Registro 91'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 91
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1091');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1092', man.id_manutencao, '2025-01-21', st.id_status, 'Importado da Base_final.csv - Registro 92'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 92
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1092');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1093', man.id_manutencao, '2025-02-01', st.id_status, 'Importado da Base_final.csv - Registro 93'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 93
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1093');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1094', man.id_manutencao, '2025-04-26', st.id_status, 'Importado da Base_final.csv - Registro 94'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 94
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1094');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1095', man.id_manutencao, '2025-03-01', st.id_status, 'Importado da Base_final.csv - Registro 95'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 95
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1095');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1096', man.id_manutencao, '2025-01-22', st.id_status, 'Importado da Base_final.csv - Registro 96'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 96
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1096');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1097', man.id_manutencao, '2025-05-05', st.id_status, 'Importado da Base_final.csv - Registro 97'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 97
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1097');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1098', man.id_manutencao, '2025-06-02', st.id_status, 'Importado da Base_final.csv - Registro 98'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 98
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1098');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1099', man.id_manutencao, '2025-04-07', st.id_status, 'Importado da Base_final.csv - Registro 99'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 99
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1099');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1100', man.id_manutencao, '2025-12-03', st.id_status, 'Importado da Base_final.csv - Registro 100'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 100
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1100');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1101', man.id_manutencao, '2025-03-05', st.id_status, 'Importado da Base_final.csv - Registro 101'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 101
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1101');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1102', man.id_manutencao, '2025-02-16', st.id_status, 'Importado da Base_final.csv - Registro 102'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 102
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1102');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1103', man.id_manutencao, '2025-04-28', st.id_status, 'Importado da Base_final.csv - Registro 103'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 103
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1103');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1104', man.id_manutencao, '2025-02-23', st.id_status, 'Importado da Base_final.csv - Registro 104'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 104
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1104');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1105', man.id_manutencao, '2025-02-14', st.id_status, 'Importado da Base_final.csv - Registro 105'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 105
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1105');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1106', man.id_manutencao, '2025-10-01', st.id_status, 'Importado da Base_final.csv - Registro 106'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 106
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1106');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1107', man.id_manutencao, '2025-04-25', st.id_status, 'Importado da Base_final.csv - Registro 107'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 107
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1107');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1108', man.id_manutencao, '2025-03-13', st.id_status, 'Importado da Base_final.csv - Registro 108'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 108
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1108');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1109', man.id_manutencao, '2025-05-31', st.id_status, 'Importado da Base_final.csv - Registro 109'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 109
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1109');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1110', man.id_manutencao, '2025-02-19', st.id_status, 'Importado da Base_final.csv - Registro 110'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 110
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1110');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1111', man.id_manutencao, '2025-03-05', st.id_status, 'Importado da Base_final.csv - Registro 111'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 111
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1111');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1112', man.id_manutencao, '2025-01-08', st.id_status, 'Importado da Base_final.csv - Registro 112'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 112
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1112');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1113', man.id_manutencao, '2025-01-15', st.id_status, 'Importado da Base_final.csv - Registro 113'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 113
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1113');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1114', man.id_manutencao, '2025-09-06', st.id_status, 'Importado da Base_final.csv - Registro 114'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 114
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1114');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1115', man.id_manutencao, '2025-02-22', st.id_status, 'Importado da Base_final.csv - Registro 115'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 115
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1115');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1116', man.id_manutencao, '2025-05-13', st.id_status, 'Importado da Base_final.csv - Registro 116'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 116
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1116');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1117', man.id_manutencao, '2025-06-01', st.id_status, 'Importado da Base_final.csv - Registro 117'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 117
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1117');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1118', man.id_manutencao, '2025-06-13', st.id_status, 'Importado da Base_final.csv - Registro 118'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 118
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1118');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1119', man.id_manutencao, '2025-05-06', st.id_status, 'Importado da Base_final.csv - Registro 119'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 119
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1119');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1120', man.id_manutencao, '2025-10-03', st.id_status, 'Importado da Base_final.csv - Registro 120'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 120
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1120');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1121', man.id_manutencao, '2025-04-05', st.id_status, 'Importado da Base_final.csv - Registro 121'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 121
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1121');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1122', man.id_manutencao, '2025-05-20', st.id_status, 'Importado da Base_final.csv - Registro 122'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 122
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1122');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1123', man.id_manutencao, '2025-03-15', st.id_status, 'Importado da Base_final.csv - Registro 123'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 123
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1123');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1124', man.id_manutencao, '2025-02-15', st.id_status, 'Importado da Base_final.csv - Registro 124'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 124
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1124');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1125', man.id_manutencao, '2025-05-13', st.id_status, 'Importado da Base_final.csv - Registro 125'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 125
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1125');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1126', man.id_manutencao, '2025-01-02', st.id_status, 'Importado da Base_final.csv - Registro 126'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 126
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1126');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1127', man.id_manutencao, '2025-08-03', st.id_status, 'Importado da Base_final.csv - Registro 127'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 127
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1127');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1128', man.id_manutencao, '2025-04-22', st.id_status, 'Importado da Base_final.csv - Registro 128'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 128
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1128');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1129', man.id_manutencao, '2025-03-15', st.id_status, 'Importado da Base_final.csv - Registro 129'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 129
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1129');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1130', man.id_manutencao, '2025-03-31', st.id_status, 'Importado da Base_final.csv - Registro 130'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 130
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1130');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1131', man.id_manutencao, '2025-03-25', st.id_status, 'Importado da Base_final.csv - Registro 131'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 131
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1131');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1132', man.id_manutencao, '2025-04-24', st.id_status, 'Importado da Base_final.csv - Registro 132'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 132
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1132');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1133', man.id_manutencao, '2025-03-01', st.id_status, 'Importado da Base_final.csv - Registro 133'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 133
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1133');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1134', man.id_manutencao, '2025-03-13', st.id_status, 'Importado da Base_final.csv - Registro 134'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 134
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1134');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1135', man.id_manutencao, '2025-01-18', st.id_status, 'Importado da Base_final.csv - Registro 135'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 135
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1135');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1136', man.id_manutencao, '2025-09-01', st.id_status, 'Importado da Base_final.csv - Registro 136'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 136
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1136');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1137', man.id_manutencao, '2025-04-20', st.id_status, 'Importado da Base_final.csv - Registro 137'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 137
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1137');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1138', man.id_manutencao, '2025-05-22', st.id_status, 'Importado da Base_final.csv - Registro 138'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 138
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1138');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1139', man.id_manutencao, '2025-04-10', st.id_status, 'Importado da Base_final.csv - Registro 139'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 139
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1139');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1140', man.id_manutencao, '2025-02-22', st.id_status, 'Importado da Base_final.csv - Registro 140'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 140
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1140');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1141', man.id_manutencao, '2025-03-09', st.id_status, 'Importado da Base_final.csv - Registro 141'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 141
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1141');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1142', man.id_manutencao, '2025-01-19', st.id_status, 'Importado da Base_final.csv - Registro 142'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 142
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1142');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1143', man.id_manutencao, '2025-06-12', st.id_status, 'Importado da Base_final.csv - Registro 143'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 143
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1143');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1144', man.id_manutencao, '2025-01-29', st.id_status, 'Importado da Base_final.csv - Registro 144'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 144
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1144');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1145', man.id_manutencao, '2025-04-20', st.id_status, 'Importado da Base_final.csv - Registro 145'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 145
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1145');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1146', man.id_manutencao, '2025-06-17', st.id_status, 'Importado da Base_final.csv - Registro 146'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 146
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1146');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1147', man.id_manutencao, '2025-03-19', st.id_status, 'Importado da Base_final.csv - Registro 147'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 147
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1147');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1148', man.id_manutencao, '2025-06-29', st.id_status, 'Importado da Base_final.csv - Registro 148'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 148
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1148');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1149', man.id_manutencao, '2025-06-28', st.id_status, 'Importado da Base_final.csv - Registro 149'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 149
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1149');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1150', man.id_manutencao, '2025-02-13', st.id_status, 'Importado da Base_final.csv - Registro 150'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 150
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1150');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1151', man.id_manutencao, '2025-01-04', st.id_status, 'Importado da Base_final.csv - Registro 151'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 151
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1151');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1152', man.id_manutencao, '2025-04-22', st.id_status, 'Importado da Base_final.csv - Registro 152'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 152
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1152');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1153', man.id_manutencao, '2025-06-03', st.id_status, 'Importado da Base_final.csv - Registro 153'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 153
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1153');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1154', man.id_manutencao, '2025-03-04', st.id_status, 'Importado da Base_final.csv - Registro 154'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 154
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1154');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1155', man.id_manutencao, '2025-01-21', st.id_status, 'Importado da Base_final.csv - Registro 155'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 155
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1155');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1156', man.id_manutencao, '2025-03-25', st.id_status, 'Importado da Base_final.csv - Registro 156'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 156
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1156');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1157', man.id_manutencao, '2025-03-05', st.id_status, 'Importado da Base_final.csv - Registro 157'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 157
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1157');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1158', man.id_manutencao, '2025-09-03', st.id_status, 'Importado da Base_final.csv - Registro 158'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 158
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1158');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1159', man.id_manutencao, '2025-04-05', st.id_status, 'Importado da Base_final.csv - Registro 159'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 159
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1159');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1160', man.id_manutencao, '2025-03-29', st.id_status, 'Importado da Base_final.csv - Registro 160'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 160
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1160');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1161', man.id_manutencao, '2025-07-02', st.id_status, 'Importado da Base_final.csv - Registro 161'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 161
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1161');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1162', man.id_manutencao, '2025-02-14', st.id_status, 'Importado da Base_final.csv - Registro 162'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 162
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1162');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1163', man.id_manutencao, '2025-02-28', st.id_status, 'Importado da Base_final.csv - Registro 163'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 163
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1163');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1164', man.id_manutencao, '2025-05-15', st.id_status, 'Importado da Base_final.csv - Registro 164'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 164
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1164');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1165', man.id_manutencao, '2025-05-13', st.id_status, 'Importado da Base_final.csv - Registro 165'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 165
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1165');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1166', man.id_manutencao, '2025-02-22', st.id_status, 'Importado da Base_final.csv - Registro 166'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 166
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1166');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1167', man.id_manutencao, '2025-06-22', st.id_status, 'Importado da Base_final.csv - Registro 167'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 167
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1167');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1168', man.id_manutencao, '2025-05-03', st.id_status, 'Importado da Base_final.csv - Registro 168'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 168
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1168');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1169', man.id_manutencao, '2025-01-02', st.id_status, 'Importado da Base_final.csv - Registro 169'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 169
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1169');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1170', man.id_manutencao, '2025-04-14', st.id_status, 'Importado da Base_final.csv - Registro 170'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 170
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1170');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1171', man.id_manutencao, '2025-07-03', st.id_status, 'Importado da Base_final.csv - Registro 171'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 171
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1171');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1172', man.id_manutencao, '2025-02-13', st.id_status, 'Importado da Base_final.csv - Registro 172'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 172
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1172');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1173', man.id_manutencao, '2025-04-14', st.id_status, 'Importado da Base_final.csv - Registro 173'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 173
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1173');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1174', man.id_manutencao, '2025-04-26', st.id_status, 'Importado da Base_final.csv - Registro 174'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 174
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1174');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1175', man.id_manutencao, '2025-03-04', st.id_status, 'Importado da Base_final.csv - Registro 175'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 175
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1175');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1176', man.id_manutencao, '2025-09-02', st.id_status, 'Importado da Base_final.csv - Registro 176'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 176
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1176');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1177', man.id_manutencao, '2025-04-23', st.id_status, 'Importado da Base_final.csv - Registro 177'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 177
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1177');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1178', man.id_manutencao, '2025-01-02', st.id_status, 'Importado da Base_final.csv - Registro 178'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 178
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1178');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1179', man.id_manutencao, '2025-01-12', st.id_status, 'Importado da Base_final.csv - Registro 179'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 179
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1179');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1180', man.id_manutencao, '2025-05-15', st.id_status, 'Importado da Base_final.csv - Registro 180'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 180
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1180');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1181', man.id_manutencao, '2025-04-15', st.id_status, 'Importado da Base_final.csv - Registro 181'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 181
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1181');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1182', man.id_manutencao, '2025-02-19', st.id_status, 'Importado da Base_final.csv - Registro 182'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 182
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1182');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1183', man.id_manutencao, '2025-05-29', st.id_status, 'Importado da Base_final.csv - Registro 183'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 183
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1183');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1184', man.id_manutencao, '2025-01-31', st.id_status, 'Importado da Base_final.csv - Registro 184'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 184
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1184');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1185', man.id_manutencao, '2025-05-14', st.id_status, 'Importado da Base_final.csv - Registro 185'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 185
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1185');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1186', man.id_manutencao, '2025-01-21', st.id_status, 'Importado da Base_final.csv - Registro 186'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 186
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1186');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1187', man.id_manutencao, '2025-06-30', st.id_status, 'Importado da Base_final.csv - Registro 187'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 187
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1187');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1188', man.id_manutencao, '2025-10-06', st.id_status, 'Importado da Base_final.csv - Registro 188'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 188
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1188');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1189', man.id_manutencao, '2025-06-03', st.id_status, 'Importado da Base_final.csv - Registro 189'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 189
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1189');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1190', man.id_manutencao, '2025-06-06', st.id_status, 'Importado da Base_final.csv - Registro 190'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 190
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1190');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1191', man.id_manutencao, '2025-05-29', st.id_status, 'Importado da Base_final.csv - Registro 191'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 191
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1191');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1192', man.id_manutencao, '2025-06-27', st.id_status, 'Importado da Base_final.csv - Registro 192'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 192
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1192');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1193', man.id_manutencao, '2025-01-01', st.id_status, 'Importado da Base_final.csv - Registro 193'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 193
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1193');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1194', man.id_manutencao, '2025-01-01', st.id_status, 'Importado da Base_final.csv - Registro 194'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 194
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1194');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1195', man.id_manutencao, '2025-05-19', st.id_status, 'Importado da Base_final.csv - Registro 195'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 195
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1195');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1196', man.id_manutencao, '2025-06-18', st.id_status, 'Importado da Base_final.csv - Registro 196'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 196
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1196');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1197', man.id_manutencao, '2025-01-23', st.id_status, 'Importado da Base_final.csv - Registro 197'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 197
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1197');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1198', man.id_manutencao, '2025-06-29', st.id_status, 'Importado da Base_final.csv - Registro 198'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 198
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1198');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1199', man.id_manutencao, '2025-09-01', st.id_status, 'Importado da Base_final.csv - Registro 199'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 199
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1199');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1200', man.id_manutencao, '2025-02-13', st.id_status, 'Importado da Base_final.csv - Registro 200'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 200
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1200');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1201', man.id_manutencao, '2025-02-20', st.id_status, 'Importado da Base_final.csv - Registro 201'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 201
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1201');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1202', man.id_manutencao, '2025-03-06', st.id_status, 'Importado da Base_final.csv - Registro 202'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 202
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1202');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1203', man.id_manutencao, '2025-06-19', st.id_status, 'Importado da Base_final.csv - Registro 203'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 203
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1203');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1204', man.id_manutencao, '2025-03-23', st.id_status, 'Importado da Base_final.csv - Registro 204'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 204
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1204');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1205', man.id_manutencao, '2025-03-08', st.id_status, 'Importado da Base_final.csv - Registro 205'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 205
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1205');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1206', man.id_manutencao, '2025-11-03', st.id_status, 'Importado da Base_final.csv - Registro 206'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 206
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1206');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1207', man.id_manutencao, '2025-04-21', st.id_status, 'Importado da Base_final.csv - Registro 207'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 207
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1207');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1208', man.id_manutencao, '2025-01-30', st.id_status, 'Importado da Base_final.csv - Registro 208'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 208
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1208');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1209', man.id_manutencao, '2025-07-06', st.id_status, 'Importado da Base_final.csv - Registro 209'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 209
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1209');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1210', man.id_manutencao, '2025-01-06', st.id_status, 'Importado da Base_final.csv - Registro 210'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 210
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1210');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1211', man.id_manutencao, '2025-07-01', st.id_status, 'Importado da Base_final.csv - Registro 211'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 211
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1211');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1212', man.id_manutencao, '2025-01-18', st.id_status, 'Importado da Base_final.csv - Registro 212'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 212
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1212');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1213', man.id_manutencao, '2025-03-31', st.id_status, 'Importado da Base_final.csv - Registro 213'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 213
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1213');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1214', man.id_manutencao, '2025-05-06', st.id_status, 'Importado da Base_final.csv - Registro 214'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 214
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1214');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1215', man.id_manutencao, '2025-01-18', st.id_status, 'Importado da Base_final.csv - Registro 215'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 215
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1215');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1216', man.id_manutencao, '2025-04-16', st.id_status, 'Importado da Base_final.csv - Registro 216'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 216
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1216');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1217', man.id_manutencao, '2025-09-02', st.id_status, 'Importado da Base_final.csv - Registro 217'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 217
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1217');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1218', man.id_manutencao, '2025-02-06', st.id_status, 'Importado da Base_final.csv - Registro 218'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 218
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1218');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1219', man.id_manutencao, '2025-09-02', st.id_status, 'Importado da Base_final.csv - Registro 219'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 219
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1219');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1220', man.id_manutencao, '2025-01-02', st.id_status, 'Importado da Base_final.csv - Registro 220'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 220
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1220');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1221', man.id_manutencao, '2025-12-04', st.id_status, 'Importado da Base_final.csv - Registro 221'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 221
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1221');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1222', man.id_manutencao, '2025-04-13', st.id_status, 'Importado da Base_final.csv - Registro 222'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 222
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1222');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1223', man.id_manutencao, '2025-02-21', st.id_status, 'Importado da Base_final.csv - Registro 223'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 223
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1223');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1224', man.id_manutencao, '2025-05-17', st.id_status, 'Importado da Base_final.csv - Registro 224'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 224
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1224');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1225', man.id_manutencao, '2025-03-18', st.id_status, 'Importado da Base_final.csv - Registro 225'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 225
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1225');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1226', man.id_manutencao, '2025-03-17', st.id_status, 'Importado da Base_final.csv - Registro 226'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 226
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1226');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1227', man.id_manutencao, '2025-05-04', st.id_status, 'Importado da Base_final.csv - Registro 227'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 227
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1227');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1228', man.id_manutencao, '2025-04-03', st.id_status, 'Importado da Base_final.csv - Registro 228'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 228
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1228');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1229', man.id_manutencao, '2025-05-15', st.id_status, 'Importado da Base_final.csv - Registro 229'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 229
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1229');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1230', man.id_manutencao, '2025-04-03', st.id_status, 'Importado da Base_final.csv - Registro 230'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 230
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1230');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1231', man.id_manutencao, '2025-04-24', st.id_status, 'Importado da Base_final.csv - Registro 231'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 231
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1231');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1232', man.id_manutencao, '2025-06-24', st.id_status, 'Importado da Base_final.csv - Registro 232'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 232
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1232');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1233', man.id_manutencao, '2025-03-13', st.id_status, 'Importado da Base_final.csv - Registro 233'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 233
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1233');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1234', man.id_manutencao, '2025-01-20', st.id_status, 'Importado da Base_final.csv - Registro 234'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 234
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1234');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1235', man.id_manutencao, '2025-04-06', st.id_status, 'Importado da Base_final.csv - Registro 235'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 235
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1235');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1236', man.id_manutencao, '2025-05-24', st.id_status, 'Importado da Base_final.csv - Registro 236'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 236
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1236');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1237', man.id_manutencao, '2025-01-28', st.id_status, 'Importado da Base_final.csv - Registro 237'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 237
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1237');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1238', man.id_manutencao, '2025-04-04', st.id_status, 'Importado da Base_final.csv - Registro 238'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 238
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1238');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1239', man.id_manutencao, '2025-05-08', st.id_status, 'Importado da Base_final.csv - Registro 239'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 239
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1239');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1240', man.id_manutencao, '2025-01-15', st.id_status, 'Importado da Base_final.csv - Registro 240'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 240
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1240');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1241', man.id_manutencao, '2025-02-13', st.id_status, 'Importado da Base_final.csv - Registro 241'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 241
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1241');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1242', man.id_manutencao, '2025-08-03', st.id_status, 'Importado da Base_final.csv - Registro 242'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 242
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1242');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1243', man.id_manutencao, '2025-04-06', st.id_status, 'Importado da Base_final.csv - Registro 243'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 243
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1243');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1244', man.id_manutencao, '2025-06-04', st.id_status, 'Importado da Base_final.csv - Registro 244'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 244
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1244');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1245', man.id_manutencao, '2025-06-02', st.id_status, 'Importado da Base_final.csv - Registro 245'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 245
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1245');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1246', man.id_manutencao, '2025-06-24', st.id_status, 'Importado da Base_final.csv - Registro 246'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 246
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1246');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1247', man.id_manutencao, '2025-08-06', st.id_status, 'Importado da Base_final.csv - Registro 247'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 247
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1247');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1248', man.id_manutencao, '2025-03-05', st.id_status, 'Importado da Base_final.csv - Registro 248'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 248
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1248');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1249', man.id_manutencao, '2025-01-21', st.id_status, 'Importado da Base_final.csv - Registro 249'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 249
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1249');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1250', man.id_manutencao, '2025-03-20', st.id_status, 'Importado da Base_final.csv - Registro 250'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 250
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1250');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1251', man.id_manutencao, '2025-04-23', st.id_status, 'Importado da Base_final.csv - Registro 251'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 251
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1251');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1252', man.id_manutencao, '2025-02-10', st.id_status, 'Importado da Base_final.csv - Registro 252'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 252
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1252');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1253', man.id_manutencao, '2025-09-02', st.id_status, 'Importado da Base_final.csv - Registro 253'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 253
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1253');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1254', man.id_manutencao, '2025-11-03', st.id_status, 'Importado da Base_final.csv - Registro 254'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 254
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1254');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1255', man.id_manutencao, '2025-02-19', st.id_status, 'Importado da Base_final.csv - Registro 255'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 255
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1255');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1256', man.id_manutencao, '2025-04-03', st.id_status, 'Importado da Base_final.csv - Registro 256'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 256
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1256');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1257', man.id_manutencao, '2025-02-27', st.id_status, 'Importado da Base_final.csv - Registro 257'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 257
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1257');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1258', man.id_manutencao, '2025-05-22', st.id_status, 'Importado da Base_final.csv - Registro 258'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 258
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1258');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1259', man.id_manutencao, '2025-02-28', st.id_status, 'Importado da Base_final.csv - Registro 259'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 259
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1259');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1260', man.id_manutencao, '2025-01-25', st.id_status, 'Importado da Base_final.csv - Registro 260'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 260
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1260');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1261', man.id_manutencao, '2025-04-13', st.id_status, 'Importado da Base_final.csv - Registro 261'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 261
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1261');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1262', man.id_manutencao, '2025-09-04', st.id_status, 'Importado da Base_final.csv - Registro 262'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 262
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1262');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1263', man.id_manutencao, '2025-04-12', st.id_status, 'Importado da Base_final.csv - Registro 263'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 263
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1263');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1264', man.id_manutencao, '2025-06-20', st.id_status, 'Importado da Base_final.csv - Registro 264'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 264
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1264');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1265', man.id_manutencao, '2025-11-02', st.id_status, 'Importado da Base_final.csv - Registro 265'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 265
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1265');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1266', man.id_manutencao, '2025-01-03', st.id_status, 'Importado da Base_final.csv - Registro 266'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 266
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1266');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1267', man.id_manutencao, '2025-04-06', st.id_status, 'Importado da Base_final.csv - Registro 267'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 267
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1267');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1268', man.id_manutencao, '2025-01-22', st.id_status, 'Importado da Base_final.csv - Registro 268'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 268
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1268');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1269', man.id_manutencao, '2025-03-13', st.id_status, 'Importado da Base_final.csv - Registro 269'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 269
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1269');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1270', man.id_manutencao, '2025-02-20', st.id_status, 'Importado da Base_final.csv - Registro 270'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 270
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1270');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1271', man.id_manutencao, '2025-05-26', st.id_status, 'Importado da Base_final.csv - Registro 271'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 271
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1271');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1272', man.id_manutencao, '2025-05-01', st.id_status, 'Importado da Base_final.csv - Registro 272'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 272
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1272');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1273', man.id_manutencao, '2025-05-22', st.id_status, 'Importado da Base_final.csv - Registro 273'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 273
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1273');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1274', man.id_manutencao, '2025-06-13', st.id_status, 'Importado da Base_final.csv - Registro 274'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 274
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1274');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1275', man.id_manutencao, '2025-05-21', st.id_status, 'Importado da Base_final.csv - Registro 275'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 275
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1275');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1276', man.id_manutencao, '2025-01-02', st.id_status, 'Importado da Base_final.csv - Registro 276'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 276
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1276');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1277', man.id_manutencao, '2025-06-01', st.id_status, 'Importado da Base_final.csv - Registro 277'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 277
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1277');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1278', man.id_manutencao, '2025-04-17', st.id_status, 'Importado da Base_final.csv - Registro 278'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 278
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1278');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1279', man.id_manutencao, '2025-06-03', st.id_status, 'Importado da Base_final.csv - Registro 279'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 279
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1279');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1280', man.id_manutencao, '2025-06-02', st.id_status, 'Importado da Base_final.csv - Registro 280'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 280
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1280');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1281', man.id_manutencao, '2025-06-01', st.id_status, 'Importado da Base_final.csv - Registro 281'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 281
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1281');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1282', man.id_manutencao, '2025-04-28', st.id_status, 'Importado da Base_final.csv - Registro 282'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 282
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1282');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1283', man.id_manutencao, '2025-06-22', st.id_status, 'Importado da Base_final.csv - Registro 283'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 283
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1283');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1284', man.id_manutencao, '2025-10-05', st.id_status, 'Importado da Base_final.csv - Registro 284'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 284
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1284');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1285', man.id_manutencao, '2025-04-17', st.id_status, 'Importado da Base_final.csv - Registro 285'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 285
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1285');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1286', man.id_manutencao, '2025-01-27', st.id_status, 'Importado da Base_final.csv - Registro 286'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 286
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1286');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1287', man.id_manutencao, '2025-01-17', st.id_status, 'Importado da Base_final.csv - Registro 287'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 287
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1287');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1288', man.id_manutencao, '2025-03-05', st.id_status, 'Importado da Base_final.csv - Registro 288'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 288
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1288');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1289', man.id_manutencao, '2025-03-20', st.id_status, 'Importado da Base_final.csv - Registro 289'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 289
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1289');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1290', man.id_manutencao, '2025-02-21', st.id_status, 'Importado da Base_final.csv - Registro 290'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 290
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1290');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1291', man.id_manutencao, '2025-04-24', st.id_status, 'Importado da Base_final.csv - Registro 291'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 291
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1291');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1292', man.id_manutencao, '2025-06-23', st.id_status, 'Importado da Base_final.csv - Registro 292'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 292
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1292');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1293', man.id_manutencao, '2025-01-27', st.id_status, 'Importado da Base_final.csv - Registro 293'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 293
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1293');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1294', man.id_manutencao, '2025-04-18', st.id_status, 'Importado da Base_final.csv - Registro 294'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 294
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1294');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1295', man.id_manutencao, '2025-04-04', st.id_status, 'Importado da Base_final.csv - Registro 295'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 295
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1295');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1296', man.id_manutencao, '2025-01-03', st.id_status, 'Importado da Base_final.csv - Registro 296'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 296
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1296');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1297', man.id_manutencao, '2025-01-13', st.id_status, 'Importado da Base_final.csv - Registro 297'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Em andamento'
WHERE man.id_registro_original = 297
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1297');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1298', man.id_manutencao, '2025-01-16', st.id_status, 'Importado da Base_final.csv - Registro 298'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Concluída'
WHERE man.id_registro_original = 298
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1298');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1299', man.id_manutencao, '2025-02-10', st.id_status, 'Importado da Base_final.csv - Registro 299'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 299
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1299');
INSERT INTO ordem_servico (numero_os, fk_manutencao, data_abertura, fk_status, observacao)
SELECT 'OS-1300', man.id_manutencao, '2025-05-21', st.id_status, 'Importado da Base_final.csv - Registro 300'
FROM manutencao man
JOIN status_ordem st ON st.status_ordem = 'Aberta'
WHERE man.id_registro_original = 300
AND NOT EXISTS (SELECT 1 FROM ordem_servico WHERE numero_os = 'OS-1300');

-- 8) Relação OS x técnico
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1001'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1002'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1003'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1004'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1005'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1006'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1007'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1008'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1009'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1010'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1011'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1012'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1013'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1014'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1015'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1016'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1017'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1018'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1019'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1020'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1021'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1022'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1023'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1024'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1025'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1026'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1027'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1028'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1029'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1030'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1031'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1032'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1033'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1034'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1035'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1036'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1037'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1038'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1039'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1040'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1041'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1042'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1043'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1044'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1045'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1046'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1047'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1048'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1049'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1050'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1051'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1052'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1053'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1054'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1055'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1056'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1057'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1058'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1059'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1060'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1061'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1062'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1063'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1064'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1065'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1066'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1067'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1068'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1069'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1070'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1071'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1072'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1073'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1074'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1075'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1076'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1077'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1078'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1079'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1080'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1081'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1082'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1083'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1084'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1085'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1086'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1087'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1088'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1089'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1090'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1091'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1092'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1093'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1094'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1095'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1096'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1097'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1098'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1099'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1100'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1101'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1102'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1103'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1104'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1105'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1106'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1107'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1108'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1109'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1110'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1111'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1112'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1113'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1114'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1115'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1116'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1117'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1118'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1119'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1120'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1121'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1122'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1123'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1124'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1125'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1126'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1127'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1128'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1129'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1130'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1131'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1132'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1133'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1134'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1135'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1136'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1137'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1138'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1139'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1140'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1141'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1142'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1143'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1144'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1145'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1146'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1147'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1148'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1149'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1150'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1151'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1152'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1153'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1154'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1155'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1156'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1157'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1158'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1159'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1160'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1161'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1162'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1163'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1164'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1165'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1166'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1167'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1168'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1169'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1170'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1171'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1172'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1173'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1174'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1175'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1176'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1177'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1178'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1179'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1180'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1181'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1182'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1183'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1184'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1185'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1186'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1187'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1188'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1189'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1190'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1191'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1192'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1193'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1194'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1195'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1196'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1197'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1198'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1199'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1200'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1201'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1202'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1203'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1204'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1205'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1206'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1207'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1208'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1209'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1210'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1211'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1212'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1213'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1214'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1215'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1216'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1217'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1218'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1219'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1220'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1221'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1222'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1223'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1224'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1225'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1226'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1227'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1228'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1229'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1230'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1231'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1232'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1233'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1234'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1235'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1236'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC005'
WHERE os.numero_os = 'OS-1237'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1238'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1239'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1240'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1241'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1242'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1243'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1244'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1245'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1246'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1247'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1248'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1249'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1250'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1251'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1252'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1253'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1254'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1255'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1256'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1257'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1258'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1259'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1260'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1261'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1262'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1263'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1264'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1265'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1266'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC002'
WHERE os.numero_os = 'OS-1267'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1268'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1269'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1270'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1271'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1272'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1273'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC009'
WHERE os.numero_os = 'OS-1274'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1275'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1276'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1277'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1278'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1279'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1280'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1281'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1282'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1283'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1284'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1285'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1286'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC008'
WHERE os.numero_os = 'OS-1287'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1288'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1289'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1290'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC010'
WHERE os.numero_os = 'OS-1291'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1292'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1293'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC003'
WHERE os.numero_os = 'OS-1294'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC007'
WHERE os.numero_os = 'OS-1295'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC011'
WHERE os.numero_os = 'OS-1296'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC006'
WHERE os.numero_os = 'OS-1297'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC001'
WHERE os.numero_os = 'OS-1298'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC012'
WHERE os.numero_os = 'OS-1299'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);
INSERT INTO ordem_tecnico (fk_ordem, fk_tecnico)
SELECT os.id_ordem, tec.id_tecnico
FROM ordem_servico os
JOIN tecnico tec ON tec.codigo_tecnico = 'TEC004'
WHERE os.numero_os = 'OS-1300'
AND NOT EXISTS (
    SELECT 1 FROM ordem_tecnico ot
    WHERE ot.fk_ordem = os.id_ordem AND ot.fk_tecnico = tec.id_tecnico
);

-- 9) Relação OS x peça
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1001'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1002'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1003'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1004'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1005'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1006'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1007'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1008'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1009'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1010'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1011'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1012'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1013'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1014'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1015'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1016'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1017'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1018'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1019'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1020'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1021'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1022'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1023'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1024'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1025'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1026'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1027'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1028'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1029'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1030'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1031'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1032'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1033'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1034'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1035'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1036'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1037'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1038'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1039'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1040'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1041'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1042'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1043'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1044'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1045'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1046'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1047'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1048'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1049'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1050'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1051'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1052'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1053'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1054'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1055'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1056'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1057'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1058'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1059'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1060'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1061'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1062'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1063'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1064'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1065'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1066'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1067'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1068'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1069'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1070'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1071'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1072'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1073'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1074'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1075'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1076'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1077'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1078'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1079'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1080'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1081'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1082'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1083'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1084'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1085'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1086'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1087'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1088'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1089'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1090'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1091'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1092'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1093'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1094'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1095'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1096'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1097'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1098'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1099'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1100'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1101'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1102'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1103'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1104'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1105'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1106'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1107'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1108'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1109'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1110'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1111'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1112'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1113'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1114'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1115'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1116'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1117'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1118'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1119'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1120'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1121'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1122'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1123'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1124'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1125'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1126'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1127'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1128'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1129'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1130'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1131'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1132'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1133'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1134'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1135'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1136'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1137'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1138'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1139'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1140'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1141'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1142'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1143'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1144'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1145'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1146'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1147'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1148'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1149'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1150'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1151'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1152'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1153'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1154'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1155'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1156'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1157'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1158'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1159'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1160'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1161'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1162'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1163'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1164'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1165'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1166'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1167'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1168'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1169'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1170'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1171'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1172'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1173'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1174'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1175'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1176'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1177'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1178'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1179'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1180'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1181'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1182'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1183'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1184'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1185'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1186'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1187'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1188'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1189'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1190'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1191'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1192'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1193'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1194'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1195'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1196'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1197'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1198'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1199'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1200'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1201'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1202'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1203'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1204'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1205'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1206'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1207'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1208'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1209'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1210'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1211'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1212'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1213'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1214'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1215'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1216'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1217'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1218'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1219'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1220'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1221'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1222'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1223'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1224'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1225'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1226'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1227'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1228'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1229'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1230'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1231'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1232'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1233'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1234'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1235'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1236'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1237'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1238'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1239'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1240'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1241'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1242'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1243'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1244'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1245'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1246'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1247'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1248'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1249'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1250'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1251'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1252'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1253'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1254'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1255'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1256'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1257'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1258'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1259'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1260'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1261'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1262'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1263'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1264'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1265'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1266'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1267'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1268'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1269'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1270'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1271'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1272'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1273'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1274'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1275'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 2
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1276'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1277'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1278'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Sensor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1279'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1280'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1281'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1282'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1283'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1284'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 7
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1285'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1286'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1287'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1288'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1289'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1290'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 3
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Válvula' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1291'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1292'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 9
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Rolamento' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1293'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 1
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Siemens'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1294'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 4
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1295'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'WEG'
JOIN peca p ON p.nome_peca = 'Correia' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1296'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 10
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Filtro' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1297'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 8
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Schneider'
JOIN peca p ON p.nome_peca = 'CLP' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1298'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 6
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Bosch'
JOIN peca p ON p.nome_peca = 'Bomba' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1299'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);
INSERT INTO ordem_peca (fk_ordem, fk_peca, quantidade)
SELECT os.id_ordem, p.id_peca, 5
FROM ordem_servico os
JOIN fabricante_peca fp ON fp.nome_fabricante = 'Fanuc'
JOIN peca p ON p.nome_peca = 'Motor' AND p.fk_fabricante = fp.id_fabricante
WHERE os.numero_os = 'OS-1300'
AND NOT EXISTS (
    SELECT 1 FROM ordem_peca op
    WHERE op.fk_ordem = os.id_ordem AND op.fk_peca = p.id_peca
);

COMMIT;

-- Conferências rápidas após a carga
SELECT COUNT(*) AS total_maquinas FROM maquina;
SELECT COUNT(*) AS total_pecas FROM peca;
SELECT COUNT(*) AS total_manutencoes FROM manutencao;
SELECT COUNT(*) AS total_ordens_servico FROM ordem_servico;
SELECT COUNT(*) AS total_ordem_tecnico FROM ordem_tecnico;
SELECT COUNT(*) AS total_ordem_peca FROM ordem_peca;