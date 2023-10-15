CREATE SEQUENCE todo_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "public"."todo" (
    "id" bigint DEFAULT nextval('todo_id_seq') NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    CONSTRAINT "todo_pkey" PRIMARY KEY ("id")
) WITH (oids = false);