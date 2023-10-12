import { FiEdit, FiTrash } from 'react-icons/fi';
import { EditTask } from './EditTask';
import { DeleteTask } from './DeleteTask';

export default async function TodoList({tasks}) {
  return (
    <div className="w-full">
      <ul className="w-full">
        {tasks.map(todo => {
          return <li key={todo.id} className="p-6 my-8 overflow-hidden bg-white shadow-xl rounded-2xl flex flex-row justify-between">
            <span>
              {todo.text}
            </span>
            <div>
            <div className='flex flex-row gap-2'>
              <EditTask todo={todo}/>
              <DeleteTask todo={todo} />
            </div>
            </div>
          </li>})}
      </ul>
    </div>
  )
}