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
    #image = file("D:\\PTF_report_analyies\\LogParser\\web\\static\\ACCOUNT_PAYABLE_14754296_SHELL-LOG1-T20171113_120909-Line206.jpg")
    #resp = Response(image, mimetype="image/jpeg")
    fh = open(r'templates\ACCOUNT_PAYABLE_14754296_SHELL\ACCOUNT_PAYABLE_14754296_SHELL-LOG1-T20171113_120909-Line206.jpg', 'rb')
    a = fh.read()
    return   Response(a, mimetype="image/jpeg")

if __name__ =='__main__':
    app.run()