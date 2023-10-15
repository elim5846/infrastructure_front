"use client"; // This is a client component 👈🏽

import { useRouter } from "next/navigation";
import { useState } from "react";
import { v4 as uuidv4 } from "uuid";
import { addTodo } from "../api";
import Modal from "./Modal";

export const AddTask = ({setLoading}) => {
    const router = useRouter();
    const [modalOpen, setModalOpen] = useState(false);
    const [newTaskValue, setNewTaskValue] = useState("");
  
    const handleSubmitNewTodo = async (e) => {
      e.preventDefault();
      setLoading(true);
      await addTodo({
        id: uuidv4(),
        title: newTaskValue,
        description: newTaskValue
      });
      setLoading(false);
      setNewTaskValue("");
      setModalOpen(false);
      router.refresh();
    };

    return <div>
      <button className="btn btn-primary w-full" onClick={() => {setModalOpen(true)}}>ADD NEW TASK +</button>
      <Modal isOpen={modalOpen} setIsOpen={setModalOpen} title={"Add new task"} validate={"SUBMIT"} onValidate={handleSubmitNewTodo} inputChange={setNewTaskValue} value={newTaskValue}/>
    </div>
}
