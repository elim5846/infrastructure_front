import { EditTask } from './EditTask';
import { DeleteTask } from './DeleteTask';

export default function TodoList({data, isLoading, setLoading}) {
  if (isLoading) return <div className="w-full"><p>Loading...</p></div>
  if (!data) return <div className="w-full"><p>No Task</p></div>
  return (
    <div className="w-full">
      <ul className="w-full">
        {data.map(todo => {
          return <li key={todo.id} className="p-6 my-8 overflow-hidden bg-white shadow-xl rounded-2xl flex flex-row justify-between">
            <span>
              {todo.title}
            </span>
            <div>
            <div className='flex flex-row gap-2'>
              <EditTask todo={todo} setLoading={setLoading}/>
              <DeleteTask todo={todo} setLoading={setLoading}/>
            </div>
            </div>
          </li>})}
      </ul>
    </div>
  )
}