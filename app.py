# import transformer.transformer as transformer

import os
import sys

from flask import Flask, escape, request
from transformer.transformer import transform_xml
from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
logger = logging.get_logger(__name__, config=config)

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '.')))

app = Flask(__name__)

@app.route('/v1/transform/', methods=['POST'])
def transform():
    logger.info("Transforming", request=request.get_json())
    return str(transform_xml(request.get_json()['xml'], 'vrt'))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
