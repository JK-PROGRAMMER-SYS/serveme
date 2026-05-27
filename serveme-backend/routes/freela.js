const express = require('express');
const router = express.Router();
const pool = require('../db'); // conexão com PostgreSQL

// GET dados do freelancer
router.get('/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const result = await pool.query(
            'SELECT cpf, experiencia_texto, especialidades, disponibilidade_status, nota_media FROM freela WHERE user_id = $1',
            [userId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Freelancer não encontrado' });
        }

        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Erro ao buscar freelancer' });
    }
});

module.exports = router;
