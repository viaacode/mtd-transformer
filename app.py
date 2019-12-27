# -*- coding: utf-8 -*-
# import transformer.transformer as transformer

import os
import sys
import functools

from flask import Flask, abort, escape, request
from transformer.transformer import Transformer
from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
logger = logging.get_logger(__name__, config=config)

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), ".")))

app = Flask(__name__)


def log_request(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        logger.info(
            "Incoming transformation request",
            request=request.data,
            request_id=request.headers.get("x-viaa-request-id"),
        )

        return func(*args, **kwargs)

    return wrapper


@app.route("/v1/transform/", methods=["POST"])
@log_request
def transform():
    input_type = request.headers.get("Content-Type").split("/")[-1]
    data = request.data
    transformation = request.args.get("transformation")

    try:
        result = Transformer().transform(input_type, data, transformation)
    except (ValueError, TypeError) as error:
            abort(400, description=str(error))

    return result


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
