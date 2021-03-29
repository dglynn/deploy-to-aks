// create todo user and db
db = new Mongo().getDB("todo");

db.createUser({
  user: "todo",
  pwd: "todo",
  roles: [
    {
      role: "dbOwner",
      db: "todo",
    },
  ],
});
