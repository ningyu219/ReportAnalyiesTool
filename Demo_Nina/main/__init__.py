from flask import Flask
from flask_pymongo import PyMongo
from flask_triangle import Triangle
from config import active_config
from flask_pymongo import PyMongo
import logging

mongo = PyMongo()
logger = logging.getLogger(__name__)


def create_app():

    app = Flask(__name__)
    Triangle(app)
    app.config.from_object(active_config)
    # active_config.init_app(app)
    mongo.init_app(app)
    return app


app = create_app()