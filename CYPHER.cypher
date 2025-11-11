
// Step 1: Clear Existing Data
MATCH (n)
DETACH DELETE n;

// Step 2: Create Nodes
CREATE (:Student {name: "Ali Balaj", age: 25, enrollment_year: 2022}),
       (:Student {name: "Amna Shahbaz", age: 23, enrollment_year: 2023}),
       (:Student {name: "Benjamin Smith", age: 26, enrollment_year: 2021});

CREATE (:Professor {name: "Dr. Jens Schuhmacher", department: "Engineering", hire_year: 2015}),
       (:Professor {name: "Dr. Ralph Hoch", department: "Computer Science", hire_year: 2010});

CREATE (:Course {name: "Data Structures", code: "CS101"}),
       (:Course {name: "Thermodynamics", code: "ENG102"});

// Step 3: Add Relationships
MATCH (prof:Professor), (course:Course)
WHERE prof.name = "Dr. Ralph Hoch" AND course.code = "CS101"
CREATE (prof)-[:TEACHES]->(course);

MATCH (prof:Professor), (course:Course)
WHERE prof.name = "Dr. Jens Schuhmacher" AND course.code = "ENG102"
CREATE (prof)-[:TEACHES]->(course);

MATCH (student:Student), (course:Course)
WHERE student.name = "Ali Balaj" AND course.code = "CS101"
CREATE (student)-[:ENROLLED_IN]->(course);

MATCH (student:Student), (course:Course)
WHERE student.name = "Amna Shahbaz" AND course.code = "ENG102"
CREATE (student)-[:ENROLLED_IN]->(course);

// Step 4: Query the Data
// 1. List all students and their courses
MATCH (s:Student)-[:ENROLLED_IN]->(c:Course)
RETURN s.name AS Student, c.name AS Course;

// 2. Find all professors teaching a specific course
MATCH (p:Professor)-[:TEACHES]->(c:Course)
WHERE c.name = "Data Structures"
RETURN p.name AS Professor, c.name AS Course;

// 3. Find courses and their enrolled students
MATCH (c:Course)<-[:ENROLLED_IN]-(s:Student)
RETURN c.name AS Course, collect(s.name) AS Students;

// Step 5: Update Data
// 1. Update a student's age
MATCH (s:Student {name: "Ali Balaj"})
SET s.age = 26
RETURN s;

// 2. Add a professor mentoring a student
MATCH (prof:Professor {name: "Dr. Ralph Hoch"}), (student:Student {name: "Amna Shahbaz"})
CREATE (prof)-[:MENTORS]->(student)
RETURN prof, student;

// Step 6: Advanced Queries
// 1. Find professors mentoring students enrolled in their courses
MATCH (prof:Professor)-[:MENTORS]->(s:Student)-[:ENROLLED_IN]->(c:Course)<-[:TEACHES]-(prof)
RETURN prof.name AS Professor, s.name AS Student, c.name AS Course;

// 2. Find students who are not enrolled in any course
MATCH (s:Student)
WHERE NOT (s)-[:ENROLLED_IN]->()
RETURN s.name AS Unenrolled_Students;

// 3. Count the number of students in each course
MATCH (c:Course)<-[:ENROLLED_IN]-(s:Student)
RETURN c.name AS Course, count(s) AS Student_Count;

// Step 7: Cleanup and Maintenance
// 1. Remove a student from a course
MATCH (s:Student)-[rel:ENROLLED_IN]->(c:Course)
WHERE s.name = "Benjamin Smith" AND c.code = "CS101"
DELETE rel;

// 2. Delete a course and all its relationships
MATCH (c:Course {code: "ENG102"})
DETACH DELETE c;



// data folder: % C:\Users\you\.Neo4jDesktop\relate-data\dbmss\dbms-048f0e3c-c8ee-44b4-bf50-101921c9b12e\import


// remove all
match (node) detach delete node

// To load the data after download the file: 
LOAD CSV WITH HEADERS FROM 'file:///worldcities.csv' AS row
CREATE (:City {name: row.city, lat: toFloat(row.lat), lng: toFloat(row.lng), 
               country: row.country, admin: row.admin_name, 
               population: toInteger(row.population)});

//Creating the relationship between nodes
MATCH (c:City) 
MERGE (co:Country {name: c.country}) 
MERGE (c)-[:LOCATED_IN]->(co);


// Query the cities in Germany (Table):
MATCH (c:City)-[:LOCATED_IN]->(co:Country {name: 'Germany'}) 
RETURN c.name, c.population;


// Query the cities in Austria (Graph)
MATCH (a:Country {name: 'Austria'})<-[:LOCATED_IN]-(c:City) 
RETURN a, c;
