import random
import time
from datetime import datetime
from faker import Faker 
from database_connect import get_conn  # our own file to connect to SQL Server

# Create a Faker object to generate fake data (like IP addresses)
fake = Faker()

# Possible user actions. "CLICK" is listed multiple times so it appears more often.
actions = ["LOGIN_SUCCESS", "LOGIN_FAILURE", "CLICK", "CLICK", "CLICK", "LOGOUT"]

# Example user IDs from 1 to 10 (pretend we have 10 users)
login_ids = list(range(1, 11))

# Function to insert one fake event into the database
def insert_event(cur):
    # Pick a random user
    login_id = random.choice(login_ids)
    # Pick a random action (weighted so some actions are more likely)
    action = random.choices(actions, weights=[5, 1, 5, 5, 5, 3])[0]
    # Generate a fake IP address
    ip = fake.ipv4_public()
    # Current UTC time
    now = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")

    # Insert the event into the CustomerAudit table
    cur.execute("""INSERT INTO dbo.CustomerAudit (LoginID, EventTime, Action, IPAddress)
        VALUES (?, ?, ?, ?)""", (login_id, now, action, ip))


# Main program starts here
if __name__ == "__main__":
    print("Producer started. CTRL + C to stop")

    # Open connection to database
    cn = get_conn()
    cur = cn.cursor()

    try:
        # Run forever until you press CTRL+C
        while True:
            # Insert between 3 and 10 random events
            for _ in range(random.randint(3, 10)):
                insert_event(cur)

            # Save changes to the database
            cn.commit()

            # Wait 1 second before generating more events
            time.sleep(1)

    # If user presses CTRL+C, stop gracefully
    except KeyboardInterrupt:
        print("Producer stopped.")

    # Always close database connection when done
    finally:
        cur.close()
        cn.close()
