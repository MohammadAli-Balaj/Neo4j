LOAD CSV WITH HEADERS FROM 'file:///worldcities.csv' AS row
CREATE (:City {name: row.city, lat: toFloat(row.lat), lng: toFloat(row.lng), 
               country: row.country, admin: row.admin_name, 
               population: toInteger(row.population)});




