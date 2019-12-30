#!/usr/bin/env python

import os
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

@cli.command(help="Transforms an input file based on a given transformation.")
@click.option("--input", "-i", "input_file", prompt=True, help="File path of the input file.")
@click.option("--output", "-o", help="Path of the output file.")
@click.option("--transformation", "-t", prompt=True, help="Transformation to be used.")
def transform(input_file, output, transformation):
    # We remove the '.' from the extension to align with the API.
    filetype = Path(input_file).suffix[1:]

    try:
        with open(input_file, "rb") as input_file:
            data = input_file.read()
    except FileNotFoundError as error:
        click.echo(click.style(f"{error}", fg="red"))
        return

    transformer = Transformer()

    try:
        result = transformer.transform(filetype, data, transformation)
    except (ValueError, TypeError) as error:
        click.echo(click.style(f"{error}", fg="red"))
        return

    if output:
        os.makedirs(os.path.dirname(output), exist_ok=True)
        # TODO: [AD-429] Handle case where transformation results in multiple output files.
        with open(output, "w") as output_file:
            output_file.write(result)

        click.echo(click.style(f"Result is written to {Path(output).absolute()}. ✨", fg="green"))
    else:
        print(result)


@cli.command(name="list", help="List all available transformations.")
def list_transformations():
    transformations = Transformer().list_transformations()

    if not transformations:
        print("No transformations available.")
        return

    print(*transformations, sep="\n")


@cli.command()
@click.option("--input", "-i", "input_file", prompt=True, help="File path of the input file.")
@click.option("--validator", "-v", prompt="Location of the XSD-file", help="Path of the output file.")
def validate(input_file, validator):
    print(input_file)
    print(validator)


if __name__ == "__main__":
    cli()
