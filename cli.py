#!/usr/bin/env python

from argparse import ArgumentParser
from pathlib import Path

import click

from transformer.transformer import Transformer

@click.group()
@click.option("--verbose", "-v", is_flag=True)
def cli(verbose):
    "Coole CLI voor metadata transformaties"
    
    if verbose:
        click.echo(click.style("VERBOOS", fg="red"))
    pass

@cli.command(short_help="Transforms an input file to a new format based on the transformation.")
@click.option("--input", "-i", "input_file", prompt=True, help="File path of the input file.")
@click.option("--output", "-o", help="Path of the output file.")
@click.option("--transformation", "-t", prompt=True, help="Transformation to be used.")
def transform(input_file, output, transformation):
    filetype = Path(input_file).suffix[1:]
    with open(input_file) as file:
        data = file.read()
    transformer = Transformer()
    click.echo(transformer.transform(filetype, data, transformation))


@cli.command()
@click.option("--input", "-i", "input_file", prompt=True, help="File path of the input file.")
@click.option("--validator", "-v", prompt="Location of the XSD-file", help="Path of the output file.")
def validate(input_file, validator):
    print(input_file)
    print(validator)


if __name__ == "__main__":
    cli()
