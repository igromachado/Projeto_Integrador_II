const API_URL = '/api/dashboard-medidas';
const charts = {};
let modoPlanejadas = false;
let dadosAtuais = null;

const formatBRL = new Intl.NumberFormat('pt-BR', {
  style: 'currency',
  currency: 'BRL'
});

const formatNumber = new Intl.NumberFormat('pt-BR', {
  minimumFractionDigits: 0,
  maximumFractionDigits: 1
});

function qs(selector) {
  return document.querySelector(selector);
}

function setText(selector, value) {
  const el = qs(selector);
  if (el) el.textContent = value;
}

function toNumber(value) {
  if (value === null || value === undefined || value === '') return 0;
  if (typeof value === 'number') return value;

  const text = String(value).trim();

  // Aceita tanto "1234.56" quanto "1.234,56".
  if (text.includes(',')) {
    return Number(text.replace(/\./g, '').replace(',', '.')) || 0;
  }

  return Number(text) || 0;
}

function getField(item, keys, fallback = '') {
  for (const key of keys) {
    if (item && item[key] !== undefined && item[key] !== null) {
      return item[key];
    }
  }
  return fallback;
}

function getLabels(rows, keys) {
  return (rows || []).map((item, index) => {
    const value = getField(item, keys, `Item ${index + 1}`);
    return String(value || `Item ${index + 1}`);
  });
}

function getNumbers(rows, keys) {
  return (rows || []).map(item => toNumber(getField(item, keys, 0)));
}

function formatTempoDiasHoras(totalHoras) {
  const horas = toNumber(totalHoras);
  const dias = Math.floor(horas / 24);
  const horasRestantes = Math.floor(horas % 24);
  const minutos = Math.round((horas - Math.floor(horas)) * 60);

  if (dias <= 0) {
    return `${horasRestantes}h ${minutos}min`;
  }

  return `${dias}d ${horasRestantes}h ${minutos}min`;
}

async function getDashboardData() {
  const response = await fetch(API_URL);
  if (!response.ok) {
    const body = await response.json().catch(() => ({}));
    throw new Error(body.erro || `Erro HTTP ${response.status}`);
  }
  return response.json();
}

function destroyChart(id) {
  if (charts[id]) {
    charts[id].destroy();
  }
}

function defaultOptions(extra = {}) {
  return {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          usePointStyle: true,
          boxWidth: 8
        }
      },
      tooltip: {}
    },
    ...extra
  };
}

function renderBarChart(id, labels, data, label, config = {}) {
  destroyChart(id);
  const ctx = document.getElementById(id);
  const horizontal = Boolean(config.horizontal);
  const chartLabels = (labels || []).map(item => String(item));
  const chartData = (data || []).map(toNumber);

  charts[id] = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: chartLabels,
      datasets: [{
        label,
        data: chartData,
        borderWidth: 1,
        borderRadius: 10
      }]
    },
    options: defaultOptions({
      indexAxis: horizontal ? 'y' : 'x',
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            title: items => items?.[0]?.label || '',
            label: context => {
              const value = horizontal ? context.parsed.x : context.parsed.y;
              if (config.money) return `${label}: ${formatBRL.format(value)}`;
              if (config.hours) return `${label}: ${formatNumber.format(value)} h`;
              return `${label}: ${formatNumber.format(value)}`;
            }
          }
        }
      },
      scales: horizontal
        ? {
            x: {
              type: 'linear',
              beginAtZero: true,
              ticks: {
                callback: config.money
                  ? value => formatBRL.format(value)
                  : value => formatNumber.format(value)
              }
            },
            y: {
              type: 'category',
              ticks: {
                autoSkip: false
              }
            }
          }
        : {
            x: {
              type: 'category',
              ticks: {
                autoSkip: false,
                maxRotation: 45,
                minRotation: 0
              }
            },
            y: {
              type: 'linear',
              beginAtZero: true,
              ticks: {
                callback: config.money
                  ? value => formatBRL.format(value)
                  : value => formatNumber.format(value)
              }
            }
          }
    })
  });
}

function renderDoughnutChart(id, labels, data) {
  destroyChart(id);
  const ctx = document.getElementById(id);
  const chartLabels = (labels || []).map(item => String(item));
  const chartData = (data || []).map(toNumber);

  charts[id] = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: chartLabels,
      datasets: [{
        label: 'Custo total',
        data: chartData,
        borderWidth: 2
      }]
    },
    options: defaultOptions({
      cutout: '58%',
      plugins: {
        legend: { position: 'bottom' },
        tooltip: {
          callbacks: {
            label: context => `${context.label}: ${formatBRL.format(toNumber(context.raw))}`
          }
        }
      }
    })
  });
}

function renderPolarChart(id, labels, data) {
  destroyChart(id);
  const ctx = document.getElementById(id);
  const chartLabels = (labels || []).map(item => String(item));
  const chartData = (data || []).map(toNumber);

  charts[id] = new Chart(ctx, {
    type: 'polarArea',
    data: {
      labels: chartLabels,
      datasets: [{
        label: 'Quantidade de OS',
        data: chartData,
        borderWidth: 2
      }]
    },
    options: defaultOptions({
      plugins: {
        legend: { position: 'bottom' },
        tooltip: {
          callbacks: {
            label: context => `${context.label}: ${formatNumber.format(toNumber(context.raw))} OS`
          }
        }
      }
    })
  });
}

function renderImpactoTiposChart(mensal) {
  const id = 'chartImpactoTipos';
  destroyChart(id);
  const ctx = document.getElementById(id);
  const rows = mensal || [];
  const labels = rows.map(item => item.mes);

  const datasets = modoPlanejadas
    ? [
        {
          label: 'Planejadas: Preventiva + Preditiva',
          data: rows.map(item => toNumber(item.planejada)),
          borderWidth: 2,
          tension: .35,
          type: 'line'
        },
        {
          label: 'Corretivas',
          data: rows.map(item => toNumber(item.corretiva)),
          borderWidth: 2,
          tension: .35,
          type: 'line'
        }
      ]
    : [
        {
          label: 'Preventivas',
          data: rows.map(item => toNumber(item.preventiva)),
          borderWidth: 1,
          borderRadius: 10,
          stack: 'manutencao'
        },
        {
          label: 'Preditivas',
          data: rows.map(item => toNumber(item.preditiva)),
          borderWidth: 1,
          borderRadius: 10,
          stack: 'manutencao'
        },
        {
          label: 'Corretivas',
          data: rows.map(item => toNumber(item.corretiva)),
          borderWidth: 1,
          borderRadius: 10,
          stack: 'manutencao'
        }
      ];

  charts[id] = new Chart(ctx, {
    type: modoPlanejadas ? 'line' : 'bar',
    data: { labels, datasets },
    options: defaultOptions({
      interaction: {
        mode: 'index',
        intersect: false
      },
      scales: {
        x: {
          type: 'category',
          stacked: !modoPlanejadas
        },
        y: {
          type: 'linear',
          beginAtZero: true,
          stacked: !modoPlanejadas,
          title: {
            display: true,
            text: 'Quantidade de manutenções'
          }
        }
      }
    })
  });
}

function renderKPIs(kpis) {
  const custo = toNumber(kpis.custo_total_manutencao);
  const horas = toNumber(kpis.tempo_total_maquinas_paradas);
  const totalOs = toNumber(kpis.total_ordens_servico);
  const abertas = toNumber(kpis.os_abertas_em_andamento);

  setText('#kpiCustoTotal', formatBRL.format(custo));
  setText('#kpiTempoParado', formatTempoDiasHoras(horas));
  setText('#kpiTempoParadoHoras', `${formatNumber.format(horas)} horas no total`);
  setText('#kpiTotalOs', formatNumber.format(totalOs));
  setText('#kpiOsAbertas', formatNumber.format(abertas));
}

function renderCharts(data) {
  renderBarChart(
    'chartMaquinasFalham',
    getLabels(data.maquinasFalhas, ['maquina', 'Maquina', 'modelo', 'Modelo']),
    getNumbers(data.maquinasFalhas, ['total_ocorrencias', 'total_os', 'ocorrencias']),
    'Ocorrências'
  );

  renderDoughnutChart(
    'chartSetoresCusto',
    getLabels(data.setoresCusto, ['setor', 'Setor', 'nome_setor']),
    getNumbers(data.setoresCusto, ['custo_total', 'Custo_Total', 'custo'])
  );

  renderBarChart(
    'chartTempoMaquina',
    getLabels(data.horasMaquinas, ['maquina', 'Maquina', 'modelo', 'Modelo']),
    getNumbers(data.horasMaquinas, ['horas_paradas', 'Horas_Parada', 'horas']),
    'Horas paradas',
    { hours: true }
  );

  renderBarChart(
    'chartTecnicosServicos',
    getLabels(data.tecnicosServicos, ['tecnico', 'Nome_Tecnico', 'nome_tecnico']),
    getNumbers(data.tecnicosServicos, ['total_os', 'Numero_OS', 'os']),
    'OS executadas',
    { horizontal: true }
  );

  renderPolarChart(
    'chartCausasFalha',
    getLabels(data.causasFalha, ['causa', 'Causa_Falha', 'causa_falha']),
    getNumbers(data.causasFalha, ['total_os', 'os'])
  );

  renderImpactoTiposChart(data.preventivasCorretivas);
}

async function carregarDashboard() {
  const status = qs('#apiStatus');

  try {
    status.textContent = 'Carregando dados do MySQL...';

    const data = await getDashboardData();
    dadosAtuais = data;
    renderKPIs(data.kpis);
    renderCharts(data);

    status.textContent = 'API conectada ao banco';
  } catch (error) {
    console.error(error);
    status.textContent = 'Erro ao conectar';
    alert(`Erro ao carregar o dashboard: ${error.message}`);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const btnAlternarPlanejadas = qs('#btnAlternarPlanejadas');

  if (btnAlternarPlanejadas) {
    btnAlternarPlanejadas.addEventListener('click', () => {
      modoPlanejadas = !modoPlanejadas;
      btnAlternarPlanejadas.textContent = modoPlanejadas
        ? 'Ver preventiva / preditiva / corretiva'
        : 'Ver planejadas x corretivas';

      if (dadosAtuais) {
        renderImpactoTiposChart(dadosAtuais.preventivasCorretivas);
      }
    });
  }

  carregarDashboard();
});
