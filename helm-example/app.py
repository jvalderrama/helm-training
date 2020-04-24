from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return "Your CUSTOM_VAR is: %s <br> Version: 1.0.1 <br> Updated automatically!"%(os.getenv('CUSTOM_VAR', "Default") )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
