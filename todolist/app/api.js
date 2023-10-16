export const baseUrl = process.env.NEXT_PUBLIC_NODE_BACK_URL ? process.env.NEXT_PUBLIC_NODE_BACK_URL : "http://localhost:3000/todo"

export const getAllTodos = async () => {
    const res = await fetch(`${baseUrl}`, { cache: "no-store" });
    const todos = await res.json();
    return todos;
};

export const editTodo = async (todo) => {
    const res = await fetch(`${baseUrl}/${todo.id}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(todo),
    });
    const updatedTodo = await res.json();
    return updatedTodo;
};

export const addTodo = async (todo) => {
    const res = await fetch(`${baseUrl}/`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(todo),
    });
    const addedTodo = await res.json();
    return addedTodo;
};

export const deleteTodo = async (todo) => {
    const res = await fetch(`${baseUrl}/${todo.id}`, {
        method: "DELETE",
    });
    const deletedTodo = await res.json();
    return deletedTodo;
};
