import logging
import os
basedir = os.path.abspath(os.path.dirname(__file__))
logger = logging.getLogger(__name__)


class Config:

    DEBUG = False
    # MONGO_URI = 'mongodb://ck:123@127.0.0.1:27017/LibraLocal?authSource=admin'
    MONGO_URI = 'mongodb://127.0.0.1:27017/Libra'



class LocalConfig(Config):
    DEBUG = True
    # MONGO_URI = 'mongodb://ck:123@127.0.0.1:27017/LibraLocal?authSource=admin'
    MONGO_URI = 'mongodb://127.0.0.1:27017/Demo'



class DevelopmentConfig(Config):
    DEBUG = True
    MONGO_URI = 'mongodb://17.87.18.79:27017/LibraDev'



class TestingConfig(Config):
    TESTING = True
    MONGO_URI = 'mongodb://17.87.18.79:27017/LibraTest'



class ProductionConfig(Config):
    MONGO_URI = 'mongodb://17.87.18.79:27017/Libra'



config = {
    'local': LocalConfig,
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,

    'default': LocalConfig

}

active_config_key = 'testing'
active_config = config.get(active_config_key)
logging.debug('Using config =====> {0}'.format(active_config_key))
