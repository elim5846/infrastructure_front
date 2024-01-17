export const baseUrl = process.env.NEXT_PUBLIC_NODE_BACK_URL ? process.env.NEXT_PUBLIC_NODE_BACK_URL : "http://localhost:3000/todo"

export const getAllTodos = async () => {
    console.log(`${baseUrl}`);
    const res = await fetch(`${baseUrl}`);
    const todos = await res.json();
    return todos;
};

export const editTodo = async (todo) => {
    console.log(`${baseUrl}`);
    const res = await fetch(`${baseUrl}/${todo.id}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(todo),
    });
    return res;
};

export const addTodo = async (todo) => {
    console.log(`${baseUrl}`);
    const res = await fetch(`${baseUrl}/`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(todo),
    });
    return res;
};

export const deleteTodo = async (todo) => {
    console.log(`${baseUrl}`);
    const res = await fetch(`${baseUrl}/${todo.id}`, {
        method: "DELETE",
    });
    return res;
};
