# -*- coding: utf-8 -*-
import os
import subprocess
from pathlib import Path

from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
logger = logging.get_logger(__name__, config=config)


class Transformer:
    def __init__(self):
        pass

    def transform(self, data):
        if not data.get("cp_id"):
            raise

        if data.get("xml"):
            return self.transform_xml(data.get("xml"), data.get("cp_id"))

        if data.get("json"):
            return self.transform_json(data.get("json"), data.get("cp_id"))

        raise

    def transform_json(self, json, cp_id):
        pass

    def transform_xml(self, xml, cp_id):
        xslt_path = self.__get_path_to_xslt(cp_id)
        saxon_path = self.__get_path_to_saxon()

        # Subprocess.run expects a byte array instead of a string as input.
        xml_bytes = str.encode(xml)

        logger.debug("Transformer", xml=xml_bytes, cp_id=cp_id, xslt=xslt_path)

        # The Saxon command receives the following parameters:
        # `-s:-` sets the source to stdin
        # `-xsl:f{xslt}` sets the xslt to be used, currently located in a file.
        result = subprocess.run(
            ["java", "-jar", saxon_path, "-s:-", f"-xsl:{xslt_path}"],
            capture_output=True,
            input=xml_bytes,
        )

        # Captured stdout needs to be decoded from bytes to string.
        return str(result.stdout.decode())

    def __get_path_to_xslt(self, cp_id):
        base_dir = os.getcwd()
        xslt_path = os.path.join(base_dir, "resources", cp_id + ".xslt")
        return xslt_path

    def __get_path_to_saxon(self):
        base_dir = os.getcwd()
        jar_path = os.path.join(base_dir, "lib", "Saxon", "saxon9he.jar")
        return jar_path
