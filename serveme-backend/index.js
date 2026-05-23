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

// Criar usuário (dados complementares após cadastro no Firebase)
app.post('/users', async (req, res) => {
  const { uid, nome, tipo, documento, contato } = req.body;

  try {
    // Insere dados básicos em users
    const userResult = await pool.query(
      'INSERT INTO users (uid, nome, tipo, contato) VALUES ($1, $2, $3, $4) RETURNING id',
      [uid, nome, tipo, contato]
    );

    const userId = userResult.rows[0].id;

    // Se for freelancer → salva CPF
    if (tipo === 'freelancer') {
      await pool.query(
        'INSERT INTO freela (user_id, cpf) VALUES ($1, $2)',
        [userId, documento]
      );
    }

    // Se for estabelecimento → salva CNPJ
    if (tipo === 'estabelecimento') {
      await pool.query(
        'INSERT INTO estab (user_id, cnpj, nome_fantasia) VALUES ($1, $2, $3)',
        [userId, documento, nome]
      );
    }

    res.json({ success: true, user_id: userId });
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

// Login: valida se UID existe no banco
app.post('/login', async (req, res) => {
  const { uid } = req.body;
  try {
    const result = await pool.query('SELECT * FROM users WHERE uid = $1', [uid]);
    if (result.rows.length > 0) {
      res.json({ success: true, user: result.rows[0] });
    } else {
      res.status(401).json({ success: false, message: 'Usuário não encontrado' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro no login' });
  }
});

// Criar vaga
app.post('/jobs', async (req, res) => {
  const { estabelecimento_id, funcao, data_hora_inicio, data_hora_fim, valor } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO jobs (estab_id, funcao, data_hora_inicio, data_hora_fim, valor, status) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [estabelecimento_id, funcao, data_hora_inicio, data_hora_fim, valor, 'aberta']
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
  const { job_id, freela_id } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO contracts (job_id, freela_id, data_confirmacao, status) VALUES ($1, $2, NOW(), $3) RETURNING *',
      [job_id, freela_id, 'confirmado']
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
  const { contract_id, valor_total, valor_freela, taxa_plataforma, metodo } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO payments (contract_id, valor_total, valor_freela, taxa_plataforma, metodo, status) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [contract_id, valor_total, valor_freela, taxa_plataforma, metodo, 'pago']
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
    const jobs = await pool.query(
      'SELECT COUNT(*) FROM jobs WHERE estab_id = $1',
      [estabelecimento_id]
    );

    const contracts = await pool.query(
      `SELECT COUNT(*) FROM contracts 
       WHERE job_id IN (SELECT id FROM jobs WHERE estab_id = $1)`,
      [estabelecimento_id]
    );

    const payments = await pool.query(
      `SELECT SUM(valor_total) FROM payments 
       WHERE contract_id IN (
         SELECT id FROM contracts WHERE job_id IN (
           SELECT id FROM jobs WHERE estab_id = $1
         )
       ) AND status = 'pago'`,
      [estabelecimento_id]
    );

    const reviews = await pool.query(
      `SELECT AVG(nota) FROM reviews 
       WHERE contract_id IN (
         SELECT id FROM contracts WHERE job_id IN (
           SELECT id FROM jobs WHERE estab_id = $1
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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
