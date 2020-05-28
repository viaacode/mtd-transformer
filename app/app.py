# -*- coding: utf-8 -*-
# import transformer.transformer as transformer

import os
import sys
import functools

from flask import Flask, abort, escape, request, jsonify
from app.transformer.transformer import Transformer
from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
logger = logging.get_logger(__name__, config=config)

app = Flask(__name__)

# TODO: [AD-451] add request logging to chassis.py.
def log_request(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        logger.info(
            "Incoming request",
            path=request.path,
            data=request.data,
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


@app.route("/v1/transformations/list", methods=["GET"])
@log_request
def list_transformations():
    transformations = Transformer().list_transformations()

    return jsonify(transformations)
