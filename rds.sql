-- --- 1. Database Backup ---
-- Backup the database to a file (not executable in SQL, but just an example of logic to be executed outside SQL)
-- mysqldump -u username -p your_database > backup_file.sql

-- --- 2. Database Restore ---
-- Restore a database from a backup file (again, this is done outside SQL)
-- mysql -u username -p your_database < backup_file.sql

-- --- 3. Monitor Long-Running Queries ---
-- Find queries running longer than 60 seconds
SELECT * 
FROM information_schema.processlist
WHERE Command != 'Sleep' AND Time > 60;

-- --- 4. Check Database Size ---
-- Get the size of all databases
SELECT table_schema "Database", 
       SUM(data_length + index_length) / 1024 / 1024 "Size (MB)" 
FROM information_schema.tables
GROUP BY table_schema;

-- --- 5. Check for Unused Indexes ---
-- Find unused indexes
SELECT table_name, index_name 
FROM information_schema.statistics 
WHERE table_schema = 'your_database' 
AND index_name NOT IN (
    SELECT index_name FROM information_schema.index_usage 
    WHERE table_schema = 'your_database'
);

-- --- 6. Verify Schema Changes ---
-- Check for missing columns after migration
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'your_database' 
AND TABLE_NAME = 'your_table' 
AND COLUMN_NAME = 'new_column';

-- --- 7. Verify Data Integrity ---
-- Check for any NULL values in a critical column
SELECT * 
FROM your_table
WHERE some_column IS NULL;

-- --- 8. Migrations / Schema Updates ---
-- Example: Add a new column to an existing table
ALTER TABLE your_table 
ADD COLUMN new_column VARCHAR(255) NOT NULL;

-- Example: Rename a column
ALTER TABLE your_table 
CHANGE old_column new_column VARCHAR(255);

-- Example: Drop an unused column
ALTER TABLE your_table 
DROP COLUMN old_column;

-- --- 9. Insert Test Data (for Testing/CI purposes) ---
-- Insert some test data into a table
INSERT INTO your_table (column1, column2, column3)
VALUES ('test_value1', 'test_value2', 'test_value3');

-- --- 10. Rollback Changes (e.g., in case of bad data) ---
-- Example: Rollback an insert operation
DELETE FROM your_table 
WHERE column1 = 'test_value1' AND column2 = 'test_value2';

-- --- 11. User Management ---
-- Create a new database user
CREATE USER 'new_user'@'%' IDENTIFIED BY 'password';

-- Grant necessary permissions to the user
GRANT ALL PRIVILEGES ON your_database.* TO 'new_user'@'%';
FLUSH PRIVILEGES;

-- --- 12. Clean Up Old Data ---
-- Remove records older than a certain date
DELETE FROM your_table WHERE created_at < '2023-01-01';

-- --- 13. Drop Unused Tables ---
-- Drop an old or unused table
DROP TABLE old_table;

-- --- 14. Monitoring & Alerts ---
-- Example: Check for slow queries (queries that run longer than 1 second)
SELECT * 
FROM information_schema.processlist
WHERE Time > 1 AND Command != 'Sleep';

-- --- 15. Rollback Database Changes ---
-- Example: Rollback a schema migration or data change
-- Revert column changes, drop columns or delete added data (if something goes wrong)
ALTER TABLE your_table DROP COLUMN new_column;
