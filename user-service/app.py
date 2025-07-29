from flask import Flask, request, jsonify
import psycopg2
import os

app = Flask(__name__)
conn = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    database="appdb",
    user="postgres",
    password="postgres"
)
cur = conn.cursor()

@app.route("/users", methods=["POST"])
def create_user():
    data = request.get_json()
    cur.execute("INSERT INTO users (name) VALUES (%s) RETURNING id", (data["name"],))
    user_id = cur.fetchone()[0]
    conn.commit()
    return jsonify({"id": user_id})

@app.route("/users", methods=["GET"])
def get_users():
    cur.execute("SELECT * FROM users")
    users = cur.fetchall()
    return jsonify(users)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
