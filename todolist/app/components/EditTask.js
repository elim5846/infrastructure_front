"use client"; // This is a client component 👈🏽

import { useRouter } from "next/navigation";
import { FiEdit } from 'react-icons/fi';
import { useState } from "react";
import { editTodo } from "../api";
import Modal from "./Modal";

export const EditTask = ({todo, setLoading}) => {
    const router = useRouter();
    const [modalOpen, setModalOpen] = useState(false);
    const [newTaskValue, setNewTaskValue] = useState(todo.text);
  
    const handleSubmitEditTodo = async (e) => {
      e.preventDefault();
      setLoading(true);
      await editTodo({
        id: todo.id,
        text: newTaskValue,
      });
      setLoading(false);
      setModalOpen(false);
      router.refresh();
    };
  
    return <div>
      <span
        style={{ cursor: "pointer" }}
        onClick={() => setModalOpen(true)}
      >
        <FiEdit size={25} color='blue'/>
      </span>
      <Modal isOpen={modalOpen} setIsOpen={setModalOpen} title={"Update task"} validate={"UPDATE"} onValidate={handleSubmitEditTodo} inputChange={setNewTaskValue} value={newTaskValue}/>
    </div>
  }