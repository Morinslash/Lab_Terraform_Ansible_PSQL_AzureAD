-- List roles and users and their access to db
SELECT
    r.rolname,
    array_agg(d.datname) FILTER (WHERE has_database_privilege(r.rolname, d.datname, 'CONNECT')) AS databases
FROM
    pg_roles r
CROSS JOIN
    pg_database d
WHERE
    r.rolname !~ '^pg_'
GROUP BY
    r.rolname
ORDER BY
    r.rolname;

-- List all roles with member of
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

--List all databases
SELECT datname FROM pg_database WHERE datistemplate = false;

--List role permissions in the database
SELECT
  grantee,
  privilege_type,
  table_schema,
  table_name
FROM
  information_schema.role_table_grants
WHERE
  grantee = current_user
ORDER BY
  table_schema,
  table_name;
---
