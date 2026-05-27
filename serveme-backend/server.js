const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Rotas
const freelaRoutes = require('./routes/freela');
const estabRoutes = require('./routes/estab');
const contractsRoutes = require('./routes/contracts');
const jobsRoutes = require('./routes/jobs');

app.use('/freela', freelaRoutes);
app.use('/estab', estabRoutes);
app.use('/contracts', contractsRoutes);
app.use('/jobs', jobsRoutes);

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
