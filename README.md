# SQL Sandbox

## Overview

This repository is a collection of SQL scripts designed to help you improve your SQL querying skills through practical exercises. It includes scripts for both MySQL and PostgreSQL and features interactive Jupyter notebooks for an engaging learning experience. The exercises are based on the course **"20277 Database Systems"** at *the Open University of Israel*.

## Content Structure

The repository is organized into four key sections, each with a specific database schema and associated SQL scripts for various practice scenarios:

1. **Gardening Database**
   - **Schema**: Detailed schema for managing gardening data.
   - **Contents**: Includes scripts for executing all basic SQL queries.

2. **Election Database**
   - **Schema**: Designed for election data management.
   - **Contents**: Includes comprehensive SQL scripts for typical data retrieval.

3. **Family Database**
   - **Schema**: Basic schema suitable for personal or small-scale applications.
   - **Contents**: Includes basic SQL queries.

4. **Clinic Database**
   - **Schema**: Initial schema setup for a clinic database.
   - **Contents**: Currently contains only the schema with plans to add queries.

## Additional Resources

The repository also provides various data formats (RDF, XML, and JSON) to facilitate the practice of data manipulation and integration techniques beyond traditional SQL.

## Example - Gardening Notebook

Here’s a glimpse into what you can do with the Gardening database using the provided Jupyter notebooks:

### Setup

```python
import sqlite3
import readline

# Establish connection to the database
conn = sqlite3.connect('gardening.db')
cursor = conn.cursor()

# Enhance command line interaction
readline.parse_and_bind("tab: complete")
readline.set_history_length(1000)
```

Function to Execute Queries

```python
def execute_query(query):
    """Execute the given SQL query and display results."""
    try:
        cursor.execute(query)
        results = cursor.fetchall()
        column_names = [desc[0] for desc in cursor.description] if cursor.description else []

        print("Results:")
        if results:
            print("\t".join(column_names))
            for row in results:
                print("\t".join(str(item) for item in row))
        else:
            print("No results found.")
    except sqlite3.Error as error:
        print(f"An error occurred: {error}")
```

### Interactive Query Execution

This section allows users to interactively enter SQL queries and see the results.

```python
try:
    while True:
        query = input("Enter a SQL query (or 'exit' to quit): ")
        if query.lower() == 'exit':
            break
        if query.strip():
            execute_query(query)
finally:
    conn.close()
```

## Contributions

Contributions to this repository are welcome! Feel free to fork the repo and submit pull requests or open issues to suggest improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
