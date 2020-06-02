# -*- coding: utf-8 -*-
# import transformer.transformer as transformer

from flask import Flask, abort, jsonify, request
from src.transformer.transformer import Transformer
from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
log = logging.get_logger(__name__, config=config)

app = Flask(__name__)


@app.route("/v1/transform/", methods=["POST"])
def transform():
    input_type = request.headers.get("Content-Type").split("/")[-1]
    data = request.data
    transformation = request.args.get("transformation")

    log.info(
        "Transforming: ",
        input_type=input_type,
        data=data,
        transformation=transformation,
    )

    try:
        result = Transformer().transform(input_type, data, transformation)
    except (ValueError, TypeError) as error:
        abort(400, description=str(error))

    return result


@app.route("/v1/transformations/list", methods=["GET"])
def list_transformations():
    transformations = Transformer().list_transformations()

    return jsonify(transformations)
