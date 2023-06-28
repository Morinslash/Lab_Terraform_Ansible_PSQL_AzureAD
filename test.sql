SELECT r.rolname AS "Role name",
       array_to_string(array[
         CASE WHEN r.rolsuper THEN 'Superuser' END,
         CASE WHEN r.rolcreaterole THEN 'Create role' END,
         CASE WHEN r.rolcreatedb THEN 'Create DB' END,
         CASE WHEN r.rolcanlogin THEN 'Can login' ELSE 'Cannot login' END,
         CASE WHEN r.rolreplication THEN 'Replication' END,
         CASE WHEN r.rolbypassrls THEN 'Bypass RLS' END
       ], ', ') AS "Granted",
       array_agg(rm.rolname) AS "Inherit from"
FROM pg_roles r
LEFT JOIN pg_auth_members m ON r.oid = m.roleid
LEFT JOIN pg_roles rm ON m.member = rm.oid
GROUP BY r.rolname, r.rolsuper, r.rolcreaterole, r.rolcreatedb, r.rolcanlogin, r.rolreplication, r.rolbypassrls
ORDER BY r.rolname;

create role "azure_ad_user";

create database testdata;
create database testdata_2;

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);

INSERT INTO customers (email, first_name, last_name) VALUES ('user@example.com', 'First', 'Last');

select * from customers;

--- Database User
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);

DROP TABLE customers;

INSERT INTO customers (email, first_name, last_name) VALUES ('user2@example.com', 'First', 'Last');

UPDATE customers
SET first_name = 'New First', last_name = 'New Last'
WHERE email = 'user@example.com';

select * from customers;

DELETE FROM customers
WHERE email = 'user@example.com';



