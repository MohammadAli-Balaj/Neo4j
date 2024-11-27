// Constraints and Indexes
CREATE CONSTRAINT IF NOT EXISTS FOR (a:Athlete) REQUIRE a.id IS UNIQUE;
CREATE INDEX IF NOT EXISTS FOR (a:Athlete) ON (a.name);
CREATE CONSTRAINT IF NOT EXISTS FOR (g:Games) REQUIRE g.name IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (c:City) REQUIRE c.name IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (c:Country) REQUIRE c.noc IS UNIQUE;
CREATE INDEX IF NOT EXISTS FOR (c:Country) ON (c.name);
CREATE CONSTRAINT IF NOT EXISTS FOR (t:Team) REQUIRE t.name IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (e:Event) REQUIRE e.name IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Medal) REQUIRE m.type IS UNIQUE;

// Load Games and link to Cities
LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.ID AS ID, line.Name AS Name, line.Sex AS Sex
MERGE (a:Athlete {id:ID}) 
ON CREATE SET a.name = Name, a.sex = Sex;

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.City AS City, line.Year AS Year, line.Season AS Season
MERGE (g:Games {name:City + ' ' + Year}) 
ON CREATE SET g.year = Year, g.season = Season;

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.City AS City
MERGE (c:City {name:City});

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.NOC AS NOC
MERGE (cou:Country {noc:NOC});

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.Team AS Team, line.Event AS Event, line.Year AS Year, line.Medal AS Medal
MERGE (t:Team {name:Team + ' ' + Event + ' ' + Year})
WITH t, Medal WHERE Medal <> 'NA'
MERGE (m:Medal {type:Medal})
MERGE (t)-[:WON]->(m);

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.Event AS Event
MERGE (e:Event {name:Event});

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.City AS City, line.Year AS Year
MATCH (g:Games {name:City + ' ' + Year})
MATCH (c:City {name:City})
MERGE (g)-[:HELD_IN]->(c);

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.Team AS Team, line.Event AS Event, line.Year AS Year, line.City AS City
MATCH (t:Team {name:Team + ' ' + Event + ' ' + Year})
MATCH (g:Games {name:City + ' ' + Year})
MERGE (t)-[:PARTICIPATED_IN]->(g);

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.Team AS Team, line.Event AS Event, line.Year AS Year
MATCH (t:Team {name:Team + ' ' + Event + ' ' + Year})
MATCH (e:Event {name:Event})
MERGE (t)-[:COMPETED_IN]->(e);

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.ID AS ID, line.Event AS Event, line.Year AS Year, line.Team AS Team
MATCH (a:Athlete {id:ID})
MATCH (t:Team {name:Team + ' ' + Event + ' ' + Year})
MERGE (a)-[:PART_OF]->(t);

LOAD CSV WITH HEADERS FROM 'https://rawcdn.githack.com/lju-lazarevic/bloom/c347841ba8474c84d2e0eb7186a5fbad036d1ca6/athlete_events.csv' AS line
WITH line WHERE line.Season='Winter'
WITH distinct line.Team AS Team, line.Event AS Event, line.Year AS Year, line.NOC AS NOC
MATCH (t:Team {name:Team + ' ' + Event + ' ' + Year})
MATCH (cou:Country {noc:NOC})
MERGE (t)-[:REPRESENTED]->(cou);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lju-lazarevic/bloom/master/noc_regions.csv?raw=true' AS line
WITH distinct line.NOC AS NOC, line.region AS region 
MATCH (c:Country {noc:NOC})
SET c.name = region;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lju-lazarevic/bloom/master/athlete_pagerank.csv?raw=true' AS line
WITH distinct line.id AS id, line.score AS score
MATCH (a:Athlete {id:id})
SET a.pageRank = toFloat(score);


