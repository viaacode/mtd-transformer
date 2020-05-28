#!/usr/bin/env python

import os
from argparse import ArgumentParser
from pathlib import Path

import click

from app.transformer.transformer import Transformer

@click.group()
@click.option("--verbose", "-v", is_flag=True)
def cli(verbose):
    "A CLI application that can be used to transform metadata."

    if verbose:
        click.echo(click.style("Verbose logging active.", fg="red"))
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
    except IOError as error:
        click.echo(click.style(f"{error}", fg="red"))
        return

    transformer = Transformer()

    try:
        result = transformer.transform(filetype, data, transformation)
    except (ValueError, TypeError) as error:
        click.echo(click.style(f"{error}", fg="red"))
        return

    if output:
        try:
            os.makedirs(os.path.dirname(output), exist_ok=True)
            with open(output, "w") as output_file:
                output_file.write(result)
        except IOError as error:
            click.echo(click.style(f"{error}", fg="red"))
            return

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


if __name__ == "__main__":
    cli()
