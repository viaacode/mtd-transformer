# -*- coding: utf-8 -*-
import os
import saxonc
from pathlib import Path
from typing import List

from viaa.configuration import ConfigParser
from viaa.observability import logging

config = ConfigParser()
log = logging.get_logger(__name__, config=config)

SUPPORTED_TYPES = ["xml", "json"]


class Transformer:
    def __init__(self):
        self.saxon_processor = saxonc.PySaxonProcessor(license=False)

    def list_transformations(self) -> List[str]:
        resources = Path("./resources")

        if not resources.exists():
            return []
        # `stem` returns the filename without extension.
        return [transformation.stem for transformation in resources.iterdir()]

    def transform(self, input_type: str, data: bytes, transformation: str) -> str:
        """Calls the correct transformation based on the input_type.

        Arguments:
            input_type {str} -- Filetype of the input, currently limited to XML, CSV or JSON.
            data {bytes} -- Input that needs to be transformed as a bytestring.
            transformation {str} -- Name of the transformation to be used.

        Raises:
            TypeError: An unsupported input type has been passed.
            ValueError: An unknown transformation has been passed.

        Returns:
            str -- The result of the metadata transformation.
        """

        if input_type not in SUPPORTED_TYPES:
            raise TypeError(
                f"'{input_type}' is not supported, please use one of the following types: {SUPPORTED_TYPES}."
            )
        if not os.path.exists(f"./resources/{transformation}"):
            raise ValueError(f"No such transformation: '{transformation}'.")

        function_for_input_type = getattr(self, f"_Transformer__transform_{input_type}")
        result = function_for_input_type(data, transformation)

        return result

    # TODO: [AD-426] Implement JSON transformations
    def __transform_json(self, json: bytes, transformation: str) -> None:
        print("Not implemented yet.")

        pass

    def __transform_xml(self, xml: bytes, transformation: str) -> str:
        xslt_path = self.__get_path_to_xslt(transformation)

        log.debug("Transformer", xml=xml, transformation=transformation, xslt=xslt_path)

        xslt_proc = self.saxon_processor.new_xslt30_processor()

        node = self.saxon_processor.parse_xml(xml_text=xml.decode("utf-8"))

        result = xslt_proc.transform_to_string(stylesheet_file=xslt_path, xdm_node= node)
        
        return result

    def __get_path_to_xslt(self, transformation: str):
        # The xslt should exist in the resources folder.
        base_dir = os.getcwd()
        xslt_path = os.path.join(base_dir, "resources", transformation, "main.xslt")
        return xslt_path
