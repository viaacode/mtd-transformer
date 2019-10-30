import os
import subprocess
from pathlib import Path

from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
logger = logging.get_logger(__name__, config=config)

def transform_xml(xml, cp_id):
    xslt_path = __get_path_to_xslt(cp_id)
    saxon_path = __get_path_to_saxon()

    # Subprocess.run expects a byte array instead of a string as input.
    xml_bytes = str.encode(xml)

    logger.debug("Transformer", xml=xml_bytes, cp_id=cp_id, xslt=xslt_path)

    # The Saxon command receives the following parameters:
    # `-s:-` sets the source to stdin
    # `-xsl:f{xslt}` sets the xslt to be used, currently located in a file, TODO: in db
    result = subprocess.run(["java", "-jar", saxon_path, "-s:-", f"-xsl:{xslt_path}"], capture_output=True, input=xml_bytes)

    # Captured stdout needs to be decoded from bytes to string.
    return result.stdout.decode()

def __get_path_to_xslt(cp_id):
    base_dir = os.getcwd()
    xslt_path = os.path.join(base_dir, "resources", cp_id + ".xslt")
    return xslt_path

def __get_path_to_saxon():
    base_dir = os.getcwd()
    jar_path = os.path.join(base_dir, "lib", "Saxon",  "saxon9he.jar")
    return jar_path
