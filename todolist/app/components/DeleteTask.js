"use client"; // This is a client component 👈🏽

import { useRouter } from "next/navigation";
import { FiTrash } from 'react-icons/fi';
import { useState } from "react";
import { deleteTodo } from "../api";
import DeleteModal from "./DeleteModal";

export const DeleteTask = ({todo}) => {
    const router = useRouter();
    const [modalOpen, setModalOpen] = useState(false);
  
    const handleSubmitDeleteTodo = async (e) => {
      e.preventDefault();
      await deleteTodo({
        id: todo.id,
      });
      setModalOpen(false);
      router.refresh();
    };
  
    return <div>
      <span
        style={{ cursor: "pointer" }}
        onClick={() => setModalOpen(true)}
      >
        <FiTrash size={25} color='red'/>
      </span>
      <DeleteModal isOpen={modalOpen} setIsOpen={setModalOpen} title={"Delete task"} validate={"DELETE"} onValidate={handleSubmitDeleteTodo}/>
    </div>
  }