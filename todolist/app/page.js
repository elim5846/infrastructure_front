import { getAllTodos } from './api';
import { AddTask } from './components/AddTask';
import TodoList from './components/toDoList';

export default async function Home() {
  const tasks = await getAllTodos();
  return (
    <main className="max-w-4xl mx-auto mt-4">
      <div className="text-center my-5 flex flex-col gap-4">
        <h1 className="text-2xl font-bold">ToDo List</h1>
        <AddTask />
      </div>
      <div className='w-full bg-slate-300 flex flex-row justify-between p-3 rounded-md'>
        <span className='font-bold'>
          TASK
        </span>
        <span className='font-bold'>
          ACTIONS
        </span>
      </div>
      <div className="text-center">
        <TodoList tasks={tasks} />
      </div>
    </main>
  )
}
