from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2
import time

app = Flask(__name__)
CORS(app)  # 🔥 Enable CORS for all routes

# Retry until PostgreSQL is ready
while True:
    try:
        conn = psycopg2.connect(
            host="postgres",
            database="appdb",
            user="appuser",
            password="apppassword"
        )
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                name TEXT NOT NULL
            );
        """)
        conn.commit()
        break
    except Exception as e:
        print("Postgres not ready, retrying...")
        time.sleep(1)

@app.route('/users', methods=['GET'])
def get_users():
    cursor.execute("SELECT * FROM users;")
    users = cursor.fetchall()
    return jsonify([{"id": u[0], "name": u[1]} for u in users])

@app.route('/users', methods=['POST'])
def create_user():
    data = request.get_json()
    cursor.execute("INSERT INTO users (name) VALUES (%s);", (data['name'],))
    conn.commit()
    return jsonify({"status": "User created"}), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
