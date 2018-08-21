from main import app
import sys
import logging
import traceback
from flask import jsonify
import logging
from view.demo_view import demo_view
logger = logging.getLogger(__name__)


app.register_blueprint(demo_view, url_prefix='/demo')



@app.errorhandler(Exception)
def handle_errors(ex):
    tb = traceback.format_exc()
    logger.error(tb)
    resp = {
        'status': 1,
        'msg': 'Something went wrong, please contact the system administrator.'
    }
    return jsonify(resp)


if __name__ == '__main__':

    app.run(host='127.0.0.1', port=5608, debug=False)






