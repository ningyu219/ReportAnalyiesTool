from flask import Flask
from flask import render_template,request,Response

import base64
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'hello world'


#path should be b64 encoded
@app.route('/logpath/<path:fname>')
def get_log_report(fname):
    return render_template(fname)


@app.route("/image/<path:fname>")
def index(fname):
    image_path = "templates/" + fname
    image_path = image_path.replace("/","\\")
    fh = open(image_path, 'rb')
    a = fh.read()
    return   Response(a, mimetype="image/jpeg")

if __name__ =='__main__':
    app.run()