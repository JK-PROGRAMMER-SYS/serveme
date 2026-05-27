const express = require('express');
const router = express.Router();
const pool = require('../db'); // conexão com PostgreSQL

// 🔹 Criar contrato quando freelancer aceita vaga
router.post('/', async (req, res) => {
    const { job_id, freela_id } = req.body;

    if (!job_id || !freela_id) {
        return res.status(400).json({ error: 'job_id e freela_id são obrigatórios' });
    }

    try {
        // Busca dados da vaga para vincular ao contrato
        const jobResult = await pool.query(
            `SELECT estab_id, valor FROM jobs WHERE id = $1 AND status = 'aberta'`,
            [job_id]
        );

        if (jobResult.rows.length === 0) {
            return res.status(404).json({ error: 'Vaga não encontrada ou já fechada' });
        }

        const { estab_id, valor } = jobResult.rows[0];

        // Cria contrato
        const contractResult = await pool.query(
            `INSERT INTO contracts (job_id, freela_id, estab_id, valor, status)
       VALUES ($1, $2, $3, $4, 'ativo')
       RETURNING *`,
            [job_id, freela_id, estab_id, valor]
        );

        // Atualiza status da vaga para "fechada"
        await pool.query(`UPDATE jobs SET status = 'fechada' WHERE id = $1`, [job_id]);

        res.json(contractResult.rows[0]); // retorna contrato criado
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao criar contrato' });
    }
});

// 🔹 Contratos de um freelancer
router.get('/freela/:freelaId', async (req, res) => {
    const { freelaId } = req.params;
    try {
        const result = await pool.query(
            `SELECT c.id, c.valor, c.status, j.funcao, j.data_hora_inicio, j.data_hora_fim, e.nome_fantasia AS estab_nome
       FROM contracts c
       JOIN jobs j ON c.job_id = j.id
       JOIN estab e ON c.estab_id = e.user_id
       WHERE c.freela_id = $1
       ORDER BY j.data_hora_inicio ASC`,
            [freelaId]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao buscar contratos do freelancer' });
    }
});

// 🔹 Contratos de um estabelecimento
router.get('/estab/:estabId', async (req, res) => {
    const { estabId } = req.params;
    try {
        const result = await pool.query(
            `SELECT c.id, c.valor, c.status, j.funcao, j.data_hora_inicio, j.data_hora_fim, f.nome AS freela_nome
       FROM contracts c
       JOIN jobs j ON c.job_id = j.id
       JOIN freela f ON c.freela_id = f.user_id
       WHERE c.estab_id = $1
       ORDER BY j.data_hora_inicio ASC`,
            [estabId]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao buscar contratos do estabelecimento' });
    }
});

module.exports = router;
