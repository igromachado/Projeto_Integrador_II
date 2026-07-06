# MetalForte - Dashboard de Gestão de Manutenção

Projeto web conectado ao banco de dados MySQL `db_metalforte`, desenvolvido com Node.js, Express, CORS, MySQL2, HTML, CSS, JavaScript e Chart.js.

Esta versão usa apenas o Dashboard 2, focado nas medidas solicitadas no Projeto Integrador:

- Custo Total com Manutenção;
- Tempo Total de Máquinas Paradas;
- Total de Ordens de Serviço;
- OS Abertas / Em Andamento;
- Máquinas que mais falham;
- Setores que geram maior custo;
- Tempo parado por máquina;
- Técnico que executa mais serviços;
- Preventivas/Preditivas versus Corretivas;
- Principais causas de falha.

## Estrutura

```text
metalforte-dashboard-dashboard2/
├── database/
│   ├── 01_modelo_metalforte.sql
│   └── 02_carga_dados_metalforte.sql
├── public/
│   ├── index.html
│   ├── style.css
│   └── script.js
├── routes/
│   └── dashboardRoutes.js
├── db.js
├── server.js
├── package.json
├── package-lock.json
├── .env.example
└── README.md
```

## Instalação

```bash
npm install
```

Crie o arquivo `.env` com base no `.env.example`:

```env
PORT=3000
CORS_ORIGIN=*

DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=sua_senha
DB_NAME=db_metalforte
```

## Banco de dados

Execute os scripts SQL na ordem:

```text
database/01_modelo_metalforte.sql
database/02_carga_dados_metalforte.sql
```

## Execução

```bash
npm start
```

Abra no navegador:

```text
http://localhost:3000
```

## Rotas da API

```text
GET /api/health
GET /api/dashboard-medidas
```

A rota `/api/dashboard-medidas` retorna todos os dados consumidos pelo dashboard em um único JSON.
