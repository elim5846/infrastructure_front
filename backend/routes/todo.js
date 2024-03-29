var express = require('express');
var router = express.Router();
require('dotenv').config();

const Pool = require('pg').Pool;

var pool = new Pool({
  user : process.env.POSTGRES_USER || 'docker',
  host: process.env.POSTGRES_HOST || 'db',
  database: process.env.POSTGRES_DB || 'todo_db',
  password: process.env.POSTGRES_PASSWORD || "docker",
  port: process.env.POSTGRES_PORT || 5432,
  connectionTimeoutMillis : 5000,
  idleTimeoutMillis : 30000
});


const getTodo = (request, response) => {
  console.log("ok")
  pool.query('SELECT * FROM todo ORDER BY id ASC', (error, results) => {
    if (error) {
      if (pool.options.host == process.env.POSTGRES_HOST) {
        pool = new Pool({
          user : process.env.POSTGRES_USER || 'docker',
          host: process.env.POSTGRES_HOST_REPLICATE || 'db',
          database: process.env.POSTGRES_DB || 'todo_db',
          password: "docker",
          port: 5432,
        });
      }
      return error;
    }
    response.status(200).json(results.rows);
  });
};

const getTodoById = (request, response) => {
  const id = parseInt(request.params.id);

  pool.query('SELECT * FROM todo WHERE id = $1', [id], (error, results) => {
    if (error) {
      if (pool.options.host == process.env.POSTGRES_HOST) {
        pool = new Pool({
          user : process.env.POSTGRES_USER || 'docker',
          host: process.env.POSTGRES_HOST_REPLICATE || 'db',
          database: process.env.POSTGRES_DB || 'todo_db',
          password: "docker",
          port: 5432,
        });
      }
      return error;
    }
    response.status(200).json(results.rows);
  });
};

const createTodo = (request, response) => {
  const { title, description } = request.body;

  pool.query(
    'INSERT INTO todo (title, description) VALUES ($1, $2) RETURNING *',
    [title, description],
    (error, results) => {
      if (error) {
        if (pool.options.host == process.env.POSTGRES_HOST) {
          pool = new Pool({
            user : process.env.POSTGRES_USER || 'docker',
            host: process.env.POSTGRES_HOST_REPLICATE || 'db',
            database: process.env.POSTGRES_DB || 'todo_db',
            password: "docker",
            port: 5432,
          });
        }
        return error;
      }
      response.status(201).send(`Todo added with ID: ${results.rows[0].id}`);
    }
  );
};

const updateTodo = (request, response) => {
  const id = parseInt(request.params.id);
  const { title, description } = request.body;

  pool.query(
    'UPDATE todo SET title = $1, description = $2 WHERE id = $3',
    [title, description, id],
    (error, results) => {
      if (error) {
        if (pool.options.host == process.env.POSTGRES_HOST) {
          pool = new Pool({
            user : process.env.POSTGRES_USER || 'docker',
            host: process.env.POSTGRES_HOST_REPLICATE || 'db',
            database: process.env.POSTGRES_DB || 'todo_db',
            password: "docker",
            port: 5432,
          });
        }
        return error;
      }
      response.status(200).send(`Todo modified with ID: ${id}`);
    }
  );
};

const deleteTodo = (request, response) => {
  const id = parseInt(request.params.id);

  pool.query('DELETE FROM todo WHERE id = $1', [id], (error, results) => {
    if (error) {
      if (pool.options.host == process.env.POSTGRES_HOST) {
        pool = new Pool({
          user : process.env.POSTGRES_USER || 'docker',
          host: process.env.POSTGRES_HOST_REPLICATE || 'db',
          database: process.env.POSTGRES_DB || 'todo_db',
          password: "docker",
          port: 5432,
        });
      }
      return error;
    }
    response.status(200).send(`Todo deleted with ID: ${id}`);
  });
};

router.get('/', getTodo);
router.get('/:id', getTodoById);
router.post('/', createTodo);
router.put('/:id', updateTodo);
router.delete('/:id', deleteTodo);

module.exports = router;
