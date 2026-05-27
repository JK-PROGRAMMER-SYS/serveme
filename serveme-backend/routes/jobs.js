const express = require('express');
const router = express.Router();
const pool = require('../db'); // conexão com PostgreSQL

// 🔹 Criar nova vaga
router.post('/', async (req, res) => {
    const { estab_id, funcao, data_hora_inicio, data_hora_fim, valor, status } = req.body;

    if (!estab_id || !funcao || !data_hora_inicio || !data_hora_fim || !valor) {
        return res.status(400).json({ error: 'Campos obrigatórios faltando' });
    }

    try {
        const result = await pool.query(
            `INSERT INTO jobs (estab_id, funcao, data_hora_inicio, data_hora_fim, valor, status)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
            [estab_id, funcao, data_hora_inicio, data_hora_fim, valor, status || 'aberta']
        );

        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao criar vaga' });
    }
});

// 🔹 Editar vaga existente
router.put('/:id', async (req, res) => {
    const { id } = req.params;
    const { funcao, data_hora_inicio, data_hora_fim, valor, status } = req.body;

    try {
        const result = await pool.query(
            `UPDATE jobs
       SET funcao = COALESCE($1, funcao),
           data_hora_inicio = COALESCE($2, data_hora_inicio),
           data_hora_fim = COALESCE($3, data_hora_fim),
           valor = COALESCE($4, valor),
           status = COALESCE($5, status)
       WHERE id = $6
       RETURNING *`,
            [funcao, data_hora_inicio, data_hora_fim, valor, status, id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Vaga não encontrada' });
        }

        res.json(result.rows[0]); // retorna vaga atualizada
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao atualizar vaga' });
    }
});

// 🔹 Vagas de um estabelecimento
router.get('/estab/:estabId', async (req, res) => {
    const { estabId } = req.params;
    try {
        const result = await pool.query(
            `SELECT id, funcao, data_hora_inicio, data_hora_fim, valor, status
       FROM jobs
       WHERE estab_id = $1
       ORDER BY data_hora_inicio ASC`,
            [estabId]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao buscar vagas do estabelecimento' });
    }
});

// 🔹 Todas as vagas abertas
router.get('/list', async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT j.id, j.funcao, j.data_hora_inicio, j.data_hora_fim, j.valor, j.status,
              e.nome_fantasia AS estab_nome
       FROM jobs j
       JOIN estab e ON j.estab_id = e.user_id
       WHERE j.status = 'aberta'
       ORDER BY j.data_hora_inicio ASC`
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao listar vagas abertas' });
    }
});

module.exports = router;
