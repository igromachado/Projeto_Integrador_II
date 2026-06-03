import express from 'express';

const app = express();

const port = 8080;

app.get('/', (req, res) => {
    return res.send("A api está rodando!")
});

app.listen(port, () => {
    console.log("O servidor está rodando em http://localhost:8080")
});