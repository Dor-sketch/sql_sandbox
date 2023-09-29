import sqlite3
import readline

# Connect to the database
conn = sqlite3.connect('gardening.db')
c = conn.cursor()

# Set up readline for console input
readline.parse_and_bind("tab: complete")
readline.set_history_length(1000)

# Define a function to execute a SQL query
def execute_query(query):
    try:
        # Execute the SQL query
        c.execute(query)
        results = c.fetchall()

        # Print the results
        if len(results) == 0:
            print("No results found.")
        else:
            for row in results:
                print(row)

        # Commit the changes to the database
        conn.commit()

        # Print a message for successful INSERT, UPDATE, or DELETE statements
        if c.rowcount > 0:
            print("Query executed successfully.")

        # Print the last inserted row ID for INSERT statements
        if query.lower().startswith('insert'):
            print("Last inserted row ID:", c.lastrowid)

    except sqlite3.Error as e:
        # Print an error message if the query fails
        print("An error occurred:", e)

# Loop to prompt the user for input
while True:
    # Prompt the user for input
    try:
        query = input("Enter a SQL query (or 'exit' to quit): ")
    except KeyboardInterrupt:
        # Handle Ctrl+C to exit the loop cleanly
        print("\nExiting...")
        break

    # Check if the user wants to exit
    if query.lower() == 'exit':
        break

    # Handle tab completion
    if '\t' in query:
        completions = [t[0] for t in c.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()]
        readline.set_completer(lambda text, state: completions[state] if state < len(completions) else None)
        readline.parse_and_bind("tab: complete")
        continue

    # Execute the SQL query on enter
    if query.endswith('\n'):
        query = query.strip()
        if query:
            execute_query(query)
        continue

    # Handle up arrow to load last query
    if query == '':
        query = readline.get_history_item(readline.get_current_history_length())

    # Execute the SQL query on semicolon
    if ';' in query:
        queries = query.split(';')
        for q in queries:
            q = q.strip()
            if q:
                execute_query(q)
        continue

    # Add the query to the history
    readline.add_history(query)

# Close the database connection
conn.close()