import sqlite3
import readline

# Connect to the database
conn = sqlite3.connect('family.db')
c = conn.cursor()

# Set up readline for console input
readline.parse_and_bind("tab: complete")
readline.set_history_length(1000)

# Define a function to execute a SQL query
def execute_query(query):
    try:
        print("=========================================")
        # Execute the SQL query
        c.execute(query)

        # Get column names
        column_names = [description[0] for description in c.description] if c.description else []

        # Print column names
        for col_name in column_names:
            print(col_name, end="\t")
        if column_names:
            print()  # New line after column names


        results = c.fetchall()

        # Print the results
        if len(results) == 0:
            print("No results found.")
        else:
            for row in results:
                print(row)

        print("=========================================")
        
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
query_lines = []
while True:
    try:
        # Check if it's the beginning of a new command
        if not query_lines:
            prompt = "Enter a SQL query (or 'exit' to quit): \n"
        else:
            prompt = ''

        line = input(prompt)
        
        # If the user just presses Enter without typing anything, consider it as execution time
        if not line.strip() and query_lines:
            query = ' '.join(query_lines)
            query_lines.clear()
            execute_query(query)
        else:
            query_lines.append(line)

    except KeyboardInterrupt:
        # Handle Ctrl+C to exit the loop cleanly
        print("\nExiting...")
        break

    # Check if the user wants to exit
    if line.lower() == 'exit':
        break

    # Handle up arrow to load last query (this remains unchanged, but might need a different approach)
    if line == '':
        query = readline.get_history_item(readline.get_current_history_length())

    # Add the query to the history (this remains unchanged)
    readline.add_history(line)

# Close the database connection
conn.close()
