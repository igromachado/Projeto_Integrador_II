const express = require('express');
const pool = require('../db');

const router = express.Router();

async function query(sql, params = []) {
  const [rows] = await pool.query(sql, params);
  return rows;
}

function first(rows, fallback = {}) {
  return Array.isArray(rows) && rows.length > 0 ? rows[0] : fallback;
}

router.get('/health', async (req, res, next) => {
  try {
    await pool.query('SELECT 1 AS ok');
    res.json({ status: 'ok', banco: process.env.DB_NAME || 'db_metalforte' });
  } catch (err) {
    next(err);
  }
});

router.get('/dashboard-medidas', async (req, res, next) => {
  try {
    const [
      kpisRows,
      maquinasFalhas,
      setoresCusto,
      horasMaquinas,
      tecnicosServicos,
      preventivasCorretivas,
      causasFalha
    ] = await Promise.all([
      query(`
        SELECT
          ROUND(IFNULL(SUM(m.custo_manutencao), 0), 2) AS custo_total_manutencao,
          ROUND(IFNULL(SUM(m.horas_paradas), 0), 2) AS tempo_total_maquinas_paradas,
          COUNT(DISTINCT os.id_ordem) AS total_ordens_servico,
          SUM(CASE WHEN so.status_ordem <> 'Concluída' THEN 1 ELSE 0 END) AS os_abertas_em_andamento
        FROM ordem_servico os
        JOIN manutencao m ON m.id_manutencao = os.fk_manutencao
        JOIN status_ordem so ON so.id_status = os.fk_status;
      `),
      query(`
        SELECT
          maq.modelo AS maquina,
          COUNT(m.id_manutencao) AS total_ocorrencias
        FROM manutencao m
        JOIN maquina maq ON maq.id_maquina = m.fk_maquina
        GROUP BY maq.modelo
        ORDER BY total_ocorrencias DESC, maq.modelo;
      `),
      query(`
        SELECT
          s.nome_setor AS setor,
          ROUND(IFNULL(SUM(m.custo_manutencao), 0), 2) AS custo_total
        FROM manutencao m
        JOIN maquina maq ON maq.id_maquina = m.fk_maquina
        JOIN setor s ON s.id_setor = maq.fk_setor
        GROUP BY s.nome_setor
        ORDER BY custo_total DESC;
      `),
      query(`
        SELECT
          maq.modelo AS maquina,
          ROUND(IFNULL(SUM(m.horas_paradas), 0), 2) AS horas_paradas
        FROM manutencao m
        JOIN maquina maq ON maq.id_maquina = m.fk_maquina
        GROUP BY maq.modelo
        ORDER BY horas_paradas DESC, maq.modelo;
      `),
      query(`
        SELECT
          CONCAT(t.nome_tecnico, ' ', t.sobrenome_tecnico) AS tecnico,
          COUNT(DISTINCT ot.fk_ordem) AS total_os
        FROM tecnico t
        LEFT JOIN ordem_tecnico ot ON ot.fk_tecnico = t.id_tecnico
        GROUP BY t.id_tecnico, tecnico
        ORDER BY total_os DESC, tecnico;
      `),
      query(`
        SELECT
          DATE_FORMAT(m.data_manutencao, '%Y-%m') AS mes,
          SUM(CASE WHEN tm.tipo_manutencao = 'Preventiva' THEN 1 ELSE 0 END) AS preventiva,
          SUM(CASE WHEN tm.tipo_manutencao = 'Preditiva' THEN 1 ELSE 0 END) AS preditiva,
          SUM(CASE WHEN tm.tipo_manutencao = 'Corretiva' THEN 1 ELSE 0 END) AS corretiva,
          SUM(CASE WHEN tm.tipo_manutencao IN ('Preventiva', 'Preditiva') THEN 1 ELSE 0 END) AS planejada
        FROM manutencao m
        JOIN tipo_manutencao tm ON tm.id_tipo_manutencao = m.fk_tipo_manutencao
        GROUP BY DATE_FORMAT(m.data_manutencao, '%Y-%m')
        ORDER BY mes;
      `),
      query(`
        SELECT
          cf.causa_falha AS causa,
          COUNT(m.id_manutencao) AS total_os
        FROM causa_falha cf
        LEFT JOIN manutencao m ON m.fk_causa_falha = cf.id_causa_falha
        GROUP BY cf.id_causa_falha, cf.causa_falha
        ORDER BY total_os DESC, cf.causa_falha;
      `)
    ]);

    res.json({
      kpis: first(kpisRows, {
        custo_total_manutencao: 0,
        tempo_total_maquinas_paradas: 0,
        total_ordens_servico: 0,
        os_abertas_em_andamento: 0
      }),
      maquinasFalhas,
      setoresCusto,
      horasMaquinas,
      tecnicosServicos,
      preventivasCorretivas,
      causasFalha
    });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
