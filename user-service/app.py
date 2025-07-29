from flask import Flask, request, jsonify
import psycopg2
import os
import time

app = Flask(__name__)

# Wait for PostgreSQL to be ready
for _ in range(10):
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            database="appdb",
            user="postgres",
            password="postgres"
        )
        break
    except psycopg2.OperationalError:
        print("Postgres not ready, retrying...")
        time.sleep(2)
else:
    raise Exception("Could not connect to PostgreSQL")

cur = conn.cursor()
cur.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name TEXT
    )
""")
conn.commit()

@app.route('/users', methods=['GET'])
def get_users():
    cur.execute("SELECT * FROM users")
    users = cur.fetchall()
    return jsonify([{'id': u[0], 'name': u[1]} for u in users])

@app.route('/users', methods=['POST'])
def create_user():
    data = request.get_json()
    name = data['name']
    cur.execute("INSERT INTO users (name) VALUES (%s) RETURNING id", (name,))
    user_id = cur.fetchone()[0]
    conn.commit()
    return jsonify({'id': user_id, 'name': name})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
