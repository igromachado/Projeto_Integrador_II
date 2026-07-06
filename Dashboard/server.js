require('dotenv').config();

const express = require('express');
const cors = require('cors');
const path = require('path');
const dashboardRoutes = require('./routes/dashboardRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/api', dashboardRoutes);

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.use((req, res) => {
  res.status(404).json({ erro: 'Rota não encontrada.' });
});

app.use((err, req, res, next) => {
  console.error('Erro interno:', err);
  res.status(500).json({
    erro: 'Erro interno no servidor.',
    detalhe: process.env.NODE_ENV === 'production' ? undefined : err.message
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
