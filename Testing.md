# Testing Configuration

- Login as Admin User to each database and 
    - Check ownership
    - Create Users table
    - Insert Data
    - Select Data created by Database-user
    - Drop Table
- Login as Database-User to Designated database
    - Member of **azure_ad_user**
    - No access to other DBs
    - No Drop, Create
    - Select data created by admin
    - Update data
    - Insert Data
    - Delete data