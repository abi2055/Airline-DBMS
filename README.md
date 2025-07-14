# Airline-DBMS

# Airline Operations Management System

This project is a full-scale **Airline Operations Database Management System** built using **SQL (IBM DB2)**. It simulates the key components of airline operations including **passengers, bookings, flights, staff, baggage, and scheduling** through a normalized relational schema. The system enables efficient data tracking, querying, and analysis across **1,000+ records**, showcasing advanced database design and SQL querying skills.

## Features
- **ER Diagram** covering major airline entities (Tickets, Passengers, Flights, Airlines, Baggage, Staff).
- **Normalized schema design** with data integrity enforced through primary/foreign keys and decomposition techniques.
- **Optimized Queries**:
    - Aggregations (`GROUP BY`), subqueries, set operations, and filtering.
    - Business-specific queries (e.g., peak routes, baggage handling, airline route analysis).
    - Use of indexes to improve query performance.
- **Sample Data** seeded using DDL scripts.
- **Performance Gains**: Achieved ~20% reduction in query execution time through relationship optimization and indexing strategies.

## Sample Use Cases
- Retrieve top airline routes by passenger volume.
- Identify underused routes and overbooked flights.
- Analyze baggage trends (e.g., overweight baggage handling).
- Extract operational insights like youngest frequent flyers, first-class ticket trends, and more.

## Tech Stack
- SQL (IBM DB2)
- ER Diagrams (draw.io)
- Relational Algebra concepts and best practices

## How to Use
1. Clone this repository.
2. Use the provided DDL scripts to create and populate the database on IBM DB2 or any compatible SQL database.
3. Run the provided `.sql` query files to explore various airline operational insights.

## ER Diagram
[View ER Diagram (PDF)](ER.pdf)
---

### Project Highlights:
> Designed to replicate real-world airline database scenarios, this project demonstrates hands-on experience in **schema design, complex SQL queries, data integrity enforcement, and performance optimization**.
