connect to se3db3;

SELECT PERSON.NAME, PERSON.AGE, PERSON.PERSONID, DIETARYPREF
FROM PERSON, PASSENGER
WHERE PERSON.PERSONID = PASSENGER.PERSONID AND (DIETARYPREF = 'Vegan' OR DIETARYPREF = 'Vegetarian') AND PERSON.AGE >= 20 AND PERSON.AGE <= 30 FETCH FIRST 10 ROWS ONLY;

SELECT MODEL, COUNT(*) AS amount
FROM AIRPLANE 
GROUP BY MODEL FETCH FIRST 10 ROWS ONLY;

SELECT AIRLINE.NAME, AIRPLANE.MODEL, COUNT(*) AS amount
FROM AIRPLANE, AIRLINE
GROUP BY AIRLINE.NAME, AIRPLANE.MODEL
HAVING AIRLINE.NAME = 'Air Canada' OR AIRLINE.NAME = 'Etihad Airways' OR AIRLINE.NAME = 'United Airlines' FETCH FIRST 10 ROWS ONLY;

SELECT TICKET.TICKETNO, AVG(BAGGAGE.TOTALWEIGHT) AS Total_Weight_avg
FROM TICKET, BAGGAGE, SCHEDULEDFLIGHT, AIRLINE
WHERE AIRLINE.NAME = 'Air Canada' AND SCHEDULEDFLIGHT.AIRLINEALIAS = AIRLINE.ALIAS AND TICKET.TICKETNO = BAGGAGE.TICKETNO AND TICKET.FLIGHTNO = SCHEDULEDFLIGHT.FLIGHTNO
GROUP BY TICKET.TICKETNO FETCH FIRST 10 ROWS ONLY;

SELECT TICKET.TICKETNO, SUM(BAGGAGE.TOTALWEIGHT) AS OversizedBaggageWeight
FROM TICKET
JOIN BAGGAGE ON TICKET.TICKETNO = BAGGAGE.TICKETNO
JOIN SCHEDULEDFLIGHT ON TICKET.FLIGHTNO = SCHEDULEDFLIGHT.FLIGHTNO 
WHERE BAGGAGE.BAGTYPE = 'oversized' AND BAGGAGE.FRAGILE = 0 AND SCHEDULEDFLIGHT.DEPDATE BETWEEN '2023-12-10' AND  '2024-01-03'  
GROUP BY TICKET.TICKETNO
HAVING SUM(BAGGAGE.TOTALWEIGHT) > 90 FETCH FIRST 10 ROWS ONLY;

SELECT TICKET.TICKETNO, SCHEDULEDFLIGHT.DEPDATE, MIN(BOOK.PRICE) AS min_price, BOOK.WEBSITE
FROM TICKET
JOIN BOOK ON TICKET.TICKETNO = BOOK.TICKETNO
JOIN SCHEDULEDFLIGHT ON TICKET.FLIGHTNO = SCHEDULEDFLIGHT.FLIGHTNO
JOIN ROUTE ON SCHEDULEDFLIGHT.ROUTEID = ROUTE.ROUTEID
WHERE ROUTE.SRCAIRPORT = 'YYZ' AND ROUTE.DSTAIRPORT = 'MCO'
GROUP BY TICKET.TICKETNO, SCHEDULEDFLIGHT.DEPDATE, BOOK.WEBSITE FETCH FIRST 10 ROWS ONLY;

SELECT ROUTE.ROUTEID, COUNT(DISTINCT AIRLINE.ALIAS) AS number_of_airlines
FROM ROUTE, AIRLINE, SCHEDULEDFLIGHT
WHERE AIRLINE.ALIAS = SCHEDULEDFLIGHT.AIRLINEALIAS AND ROUTE.ROUTEID = SCHEDULEDFLIGHT.ROUTEID
GROUP BY ROUTE.ROUTEID
HAVING COUNT(DISTINCT AIRLINE.ALIAS) >= 3 ORDER BY number_of_airlines DESC FETCH FIRST 10 ROWS ONLY; 

SELECT ROUTE.ROUTEID, ROUTE.SRCAIRPORT, ROUTE.DSTAIRPORT
FROM ROUTE
WHERE ROUTE.ROUTEID NOT IN (
    SELECT SCHEDULEDFLIGHT.ROUTEID
    FROM SCHEDULEDFLIGHT, AIRLINE
    WHERE AIRLINE.ALIAS = SCHEDULEDFLIGHT.AIRLINEALIAS
) FETCH FIRST 10 ROWS ONLY;

SELECT COUNT(DISTINCT PERSON.PERSONID) AS NumStaffPassengers
FROM PERSON
WHERE PERSON.PERSONID IN (
    SELECT PERSONID FROM PILOT
    UNION
    SELECT PERSONID FROM CABINCREW
    UNION 
    SELECT PERSONID FROM GROUNDSTAFF
) FETCH FIRST 10 ROWS ONLY;

SELECT AIRLINE.ALIAS, COUNT(PASSENGER.PERSONID) AS also_passengers
FROM PASSENGER, AIRLINE
JOIN (
    SELECT PILOT.PERSONID, AIRPLANE.AIRLINEALIAS 
    FROM PILOT, FLIES, AIRPLANE
    WHERE PILOT.PERSONID = FLIES.PILOTID AND AIRPLANE.SERIALNO = FLIES.AIRPLANESNO 
    UNION 
    SELECT CABINCREW.PERSONID, CABINCREW.AIRLINEALIAS
    FROM CABINCREW 
) AS IDS ON PASSENGER.PERSONID = IDS.PERSONID 
WHERE IDS.AIRLINEALIAS = AIRLINE.ALIAS
GROUP BY AIRLINE.ALIAS FETCH FIRST 10 ROWS ONLY;

SELECT R1.ROUTEID, R1.SRCAIRPORT, R1.DSTAIRPORT
FROM ROUTE R1
JOIN USE U1 ON R1.ROUTEID = U1.ROUTEID 
JOIN AIRLINE ON AIRLINE.ALIAS = U1.AIRLINEALIAS
WHERE AIRLINE.ALIAS = 'ACA' AND NOT EXISTS ( 
    SELECT *
    FROM ROUTE R2
    JOIN USE U2 ON R2.ROUTEID = U2.ROUTEID 
    WHERE R2.SRCAIRPORT = R1.DSTAIRPORT AND R2.DSTAIRPORT = R1.SRCAIRPORT AND U2.AIRLINEALIAS = 'ACA'
) FETCH FIRST 10 ROWS ONLY;

SELECT ROUTE.ROUTEID, ROUTE.SRCAIRPORT, ROUTE.DSTAIRPORT, COUNT(TICKET.TICKETNO) AS num_tickets_sold 
FROM ROUTE
JOIN SCHEDULEDFLIGHT ON SCHEDULEDFLIGHT.ROUTEID = ROUTE.ROUTEID
JOIN TICKET ON SCHEDULEDFLIGHT.FLIGHTNO = TICKET.FLIGHTNO
WHERE SCHEDULEDFLIGHT.DEPDATE BETWEEN '2023-12-01' AND '2023-12-31'
GROUP BY ROUTE.ROUTEID, ROUTE.SRCAIRPORT, ROUTE.DSTAIRPORT ORDER BY num_tickets_sold DESC FETCH FIRST 1 ROW ONLY;

SELECT DISTINCT SCHEDULEDFLIGHT.FLIGHTNO
FROM SCHEDULEDFLIGHT
JOIN TICKET ON SCHEDULEDFLIGHT.FLIGHTNO = TICKET.FLIGHTNO
JOIN ROUTE ON SCHEDULEDFLIGHT.ROUTEID = ROUTE.ROUTEID
JOIN AIRLINE ON SCHEDULEDFLIGHT.AIRLINEALIAS = AIRLINE.ALIAS
WHERE TICKET.CLASS = 'First' AND AIRLINE.ALIAS = 'ACA' AND ROUTE.SRCAIRPORT = 'YYZ' AND ROUTE.DSTAIRPORT = 'MCO' FETCH FIRST 10 ROWS ONLY;

SELECT A1.ALIAS, A1.NAME AS airline_name, COUNTRY.NAME AS country_name
FROM AIRLINE A1, COUNTRY 
WHERE A1.COUNTRYCODE = COUNTRY.CODE AND A1.COUNTRYCODE IN (
    SELECT A2.COUNTRYCODE
    FROM AIRLINE A2
    GROUP BY A2.COUNTRYCODE
    HAVING COUNT(A2.ALIAS) = 1
) FETCH FIRST 10 ROWS ONLY;