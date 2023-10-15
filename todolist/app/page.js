"use client"; // This is a client component 👈🏽
import TodoList from './components/toDoList';
import { AddTask } from './components/AddTask';
import { useState, useEffect } from 'react';
import { baseUrl } from './api';
import { useRouter } from 'next/navigation';

export default function Home() {
    const [data, setData] = useState(null)
  const [isLoading, setLoading] = useState(true)
  const router = useRouter();
 
  useEffect(() => {
    if (isLoading) {
        fetch(`${baseUrl}`, {cache: "no-cache"})
            .then((res) => res.json())
            .then((data) => {
                setData(data)
                setLoading(false)
                router.refresh()
        })
    }
  }, [isLoading]); // eslint-disable-line react-hooks/exhaustive-deps


  return (
    <main className="max-w-4xl mx-auto mt-4">
      <div className="text-center my-5 flex flex-col gap-4">
        <h1 className="text-2xl font-bold">ToDo List</h1>
        <AddTask setLoading={setLoading}/>
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
        <TodoList isLoading={isLoading} data={data} setLoading={setLoading}/>
      </div>
    </main>
  )
}