# Hospital Management System

## TODO

- [x] Fix bug with PRIMARY - PARTIAL keys (`tablesUpdated.sql`)
- [x] Solve the problem of 1! doctor in department (`tablesUpdated.sql`)
- [x] Make requests searchable
- [x] Bug of cyclic relaions (sender - reciever)
- [ ] Create interface
- [ ] Convert to MySQL

## How to run instruction

```java
blblblblblbl> sudo -i -u postgres
~$ psql
postgres=# CREATE DATABASE Hospital;
postgres=# \c hospital
postgres=# \i '/home/.....//HospitalManagementSystem/tablesUpdate.sql'
postgres=# \i '/home/.....//HospitalManagementSystem/fill.sql'
```
Now you can try your `SELECT` statement!