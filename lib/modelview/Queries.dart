const getAllStudentsQuery = """ 
       query getPersons{
         persons{
         id,
          name,
          lastName,
          age
       }
    }
        """;

const insertdata = """ 
       mutation AddNewBook (\$id: ID, \$name: String, \$lastName: String, \$age : Int) { 
  addPerson(id: \$id, name: \$name, lastName: \$lastName, age: \$age ) {
    id
    name
    lastName
    age
  }
} 
        """;
const updatedata = """
mutation UpdateBook(\$id: ID, \$name: String, \$lastName: String, \$age : Int) { 
  editPerson(id: \$id, name : \$name, lastName : \$lastName, age : \$age) {
    id
    name
    lastName
    age
  }
} """;