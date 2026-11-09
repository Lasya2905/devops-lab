from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>DevOps Lab App</h1><p>Built with Git, Jenkins, Docker, Kubernetes</p>"

@app.route("/health")
def health():
    return jsonify(status="ok")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
