const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Conexão com PostgreSQL
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

// Rota teste
app.get('/', (req, res) => {
  res.send('API ServeMe funcionando!');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});

// Criar usuário
app.post('/users', async (req, res) => {
  const { uid, nome, tipo, documento } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO users (uid, nome, tipo, documento) VALUES ($1, $2, $3, $4) RETURNING *',
      [uid, nome, tipo, documento]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao cadastrar usuário' });
  }
});

// Listar usuários
app.get('/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao buscar usuários' });
  }
});

// Criar vaga
app.post('/jobs', async (req, res) => {
  const { estabelecimento_id, funcao, data_hora, valor } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO jobs (estabelecimento_id, funcao, data_hora, valor) VALUES ($1, $2, $3, $4) RETURNING *',
      [estabelecimento_id, funcao, data_hora, valor]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao criar vaga' });
  }
});

// Listar vagas
app.get('/jobs', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM jobs WHERE status = $1', ['aberta']);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao buscar vagas' });
  }
});

// Criar contrato (freelancer aceita vaga)
app.post('/contracts', async (req, res) => {
  const { job_id, freelancer_id } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO contracts (job_id, freelancer_id, data_confirmacao, status) VALUES ($1, $2, NOW(), $3) RETURNING *',
      [job_id, freelancer_id, 'confirmado']
    );

    // Atualiza status da vaga para "fechada"
    await pool.query('UPDATE jobs SET status = $1 WHERE id = $2', ['fechada', job_id]);

    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao criar contrato' });
  }
});

// Listar contratos
app.get('/contracts', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM contracts');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao buscar contratos' });
  }
});

// Registrar pagamento
app.post('/payments', async (req, res) => {
  const { contract_id, valor, metodo } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO payments (contract_id, valor, metodo, status) VALUES ($1, $2, $3, $4) RETURNING *',
      [contract_id, valor, metodo, 'pago']
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao registrar pagamento' });
  }
});

// Listar pagamentos
app.get('/payments', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM payments');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao buscar pagamentos' });
  }
});

// Criar avaliação
app.post('/reviews', async (req, res) => {
  const { contract_id, avaliador, nota, comentario } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO reviews (contract_id, avaliador, nota, comentario) VALUES ($1, $2, $3, $4) RETURNING *',
      [contract_id, avaliador, nota, comentario]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao criar avaliação' });
  }
});

// Listar avaliações
app.get('/reviews', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM reviews');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao buscar avaliações' });
  }
});

// Relatório consolidado para um Estabelecimento Parceiro
app.get('/dashboard/:estabelecimento_id', async (req, res) => {
  const { estabelecimento_id } = req.params;

  try {
    // Total de vagas criadas
    const jobs = await pool.query(
      'SELECT COUNT(*) FROM jobs WHERE estabelecimento_id = $1',
      [estabelecimento_id]
    );

    // Total de contratos fechados
    const contracts = await pool.query(
      `SELECT COUNT(*) FROM contracts 
       WHERE job_id IN (SELECT id FROM jobs WHERE estabelecimento_id = $1)`,
      [estabelecimento_id]
    );

    // Total de pagamentos realizados
    const payments = await pool.query(
      `SELECT SUM(valor) FROM payments 
       WHERE contract_id IN (
         SELECT id FROM contracts WHERE job_id IN (
           SELECT id FROM jobs WHERE estabelecimento_id = $1
         )
       ) AND status = 'pago'`,
      [estabelecimento_id]
    );

    // Média das avaliações recebidas
    const reviews = await pool.query(
      `SELECT AVG(nota) FROM reviews 
       WHERE contract_id IN (
         SELECT id FROM contracts WHERE job_id IN (
           SELECT id FROM jobs WHERE estabelecimento_id = $1
         )
       ) AND avaliador = 'freelancer'`,
      [estabelecimento_id]
    );

    res.json({
      total_vagas: jobs.rows[0].count,
      total_contratos: contracts.rows[0].count,
      total_pagamentos: payments.rows[0].sum || 0,
      media_avaliacoes: reviews.rows[0].avg || 0
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao gerar relatório' });
  }
});
