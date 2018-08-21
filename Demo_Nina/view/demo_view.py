from flask import Blueprint
from flask import render_template
from main import app

demo_view = Blueprint('demo_view', __name__)


@demo_view.route('/')
def demo():
    return render_template('pages/demo.html')