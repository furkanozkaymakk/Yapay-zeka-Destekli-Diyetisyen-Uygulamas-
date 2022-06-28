from flask import Flask, jsonify, request
from diyet import bulanik_mantik

app = Flask(__name__)

print("merhaba")
count = 0
index = 0
yas = 0


@app.route('/', methods=["GET", "POST"])
def hello_world():  # put application's code here
    global count, index
    if request.method == "GET":
        json_file = {'query': 'hello_world'}
        return jsonify(json_file)
    else:
        if count == 0:
            index = request.data.decode()
            count = count + 1
            return {"message": index}
        else:
            yas = request.data.decode()
            oran = bulanik_mantik(index, yas)
            count = 0
            return {"message": oran}


if __name__ == '__main__':
    app.run()
