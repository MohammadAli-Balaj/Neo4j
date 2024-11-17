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
