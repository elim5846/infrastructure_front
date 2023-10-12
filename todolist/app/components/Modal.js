import { Dialog } from "@headlessui/react"

export default function Modal({isOpen, setIsOpen, title, validate, onValidate, inputChange, value}) {
    return (
        <Dialog
        as="div"
        open={isOpen}
        className="fixed inset-0 z-10 overflow-y-auto"
        onClose={() => setIsOpen(false)}
      >
        <div className="min-h-screen px-4 text-center">
          <span
            className="inline-block h-screen align-middle"
            aria-hidden="true"
          >
            &#8203;
          </span>
          
            <div className="inline-block w-full max-w-md p-6 my-8 overflow-hidden text-left align-middle transition-all transform bg-white shadow-xl rounded-2xl">
              <Dialog.Title
                as="h3"
                className="text-lg font-medium leading-6 text-gray-900 flex flex-row justify-between"
              >
                <span>
                    {title}
                </span>
                <button
                  type="button"
                  className="inline-flex justify-center px-4 py-2 text-sm text-grey border border-transparent rounded-md hover:bg-red-200 duration-300"
                  onClick={() => setIsOpen(false)}
                >
                    x
                </button>
              </Dialog.Title>

              <div className="mt-4 flex flex-row gap-4">
              <input type="text" id="first_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Type here" required onChange={(e) => inputChange(e.target.value)} value={value}/>
              <form onSubmit={onValidate}>
                <button
                    type="submit"
                    className="inline-flex justify-center px-4 py-3 text-sm text-white bg-slate-600 border border-transparent rounded-md hover:bg-slate-400 duration-300"
                    >
                    {validate}
                </button>
              </form>
              </div>
          </div>
        </div>
      </Dialog>
    )
  }