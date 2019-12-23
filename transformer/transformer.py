# -*- coding: utf-8 -*-
import os
import subprocess
from pathlib import Path

from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
logger = logging.get_logger(__name__, config=config)

SUPPORTED_TYPES = ["xml", "csv", "json"] # TODO: check best practices

class Transformer:
    def __init__(self):
        pass

    def transform(self, input_type: str, data: str, transformation: str) -> str:
        if input_type not in SUPPORTED_TYPES:
            raise TypeError(f"'{input_type}' is not supported, please use one of the following types: {SUPPORTED_TYPES}.")
        if not os.path.exists(f"./resources/{transformation}"):
            raise ValueError(f"No such transformation: '{transformation}'.")

        function_for_input_type = getattr(self, f"transform_{input_type}")
        result = function_for_input_type(data, transformation)

        return result


    # TODO: Implement JSON transformations
    def transform_json(self, json: str, transformation: str) -> str:
        print("Not implemented yet.")

        pass

    # TODO: Implement CSV transformations
    def transform_csv(self, csv: str, transformation: str) -> str:
        print("Not implemented yet.")

        pass


    def transform_xml(self, xml: str, transformation: str):
        xslt_path = self.__get_path_to_xslt(transformation)
        saxon_path = self.__get_path_to_saxon()

        logger.debug("Transformer", xml=xml, cp_id=transformation, xslt=xslt_path)

        # The Saxon command receives the following parameters:
        # `-s:-` sets the source to stdin
        # `-xsl:f{xslt}` sets the xslt to be used, currently located in a file.
        result = subprocess.run(
            ["java", "-jar", saxon_path, "-s:-", f"-xsl:{xslt_path}"],
            capture_output=True,
            input=xml,
        )

        # Captured stdout needs to be decoded from bytes to string.
        return str(result.stdout.decode())

    def __get_path_to_xslt(self, transformation: str):
        # The xslt should exist in the resources folder.
        base_dir = os.getcwd()
        xslt_path = os.path.join(base_dir, "resources", transformation, "main.xslt")
        return xslt_path

    def __get_path_to_saxon(self):
        base_dir = os.getcwd()
        jar_path = os.path.join(base_dir, "lib", "Saxon", "saxon9he.jar")
        return jar_path
