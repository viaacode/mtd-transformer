# Metadate transformation service

Transforms given metadata to a new format based on a chosen transformation.


For XML-to-XML transformations Saxon HE is used under the hood. Saxon HE is (c) Michael H. Kay and released under the Mozilla MPL 1.0 (http://www.mozilla.org/MPL/1.0/)

## Prerequisites

- Python 3.8
- Java (for running Saxon HE)

## Installation

1. Clone or download the repository
2. `cd` into the directory
3. Create a virtual environment `python -m venv .`
4. Activate the environment `source bin/activate` on Linux or `Scripts/activate` on Windows.
5. Install dependencies `pip install -r requirements.txt`

## Usage

### CLI

Using the CLI you can transform a file and list the available transformations.

Output of `python cli.py --help`:

```
Usage: cli.py [OPTIONS] COMMAND [ARGS]...

Coole CLI voor metadata transformaties

Options:
-v, --verbose
--help         Show this message and exit.

Commands:
list       List all available transformations.
transform  Transforms an input file based on a given transformation.
validate
```
#### Example

`python cli.py transform --help` will give more information about the parameters.

`python cli.py transform` will prompt for an input file and a transformation.

`python cli.py transform -i C:\test.xml -t OR-rf5kf25` will transform `C:\test.xml` using the transformation specified in `./resources/OR-rf5kf25` and output the result to `stdout`

`python cli.py transform -i C:\test.xml -t OR-rf5kf25 -o C:\output\test.xml`  will transform `C:\test.xml` using the transformation specified in `./resources/OR-rf5kf25` and output the result to `C:\output\test.xml`

### API

Run `python app.py` to start the service. You will be using the Flask development server.

#### Example

To transform an XML-file, send a `POST` request to `http://0.0.0.0:5000/transform?transformation=OR-rf5kf25` with the xml in the body.
Add `application/xml` to the `Content-Type` header.

HTTP-call:
```HTTP
POST /v1/transform?transformation=OR-rf5kf25 HTTP/1.1
Host: 0.0.0.0:5000
Content-Type: application/xml

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ns8:metadataUpdatedEvent xmlns:ns6="http://www.vrt.be/schema/mig/messaging/viaa"
    xmlns:process="http://www.vrt.be/schema/mig/messaging/process"
    xmlns:ns8="http://www.vrt.be/mig/viaa"
    xmlns:ns7="http://www.vrt.be/mig/viaa/api"
    xmlns:ns9="http://www.vrt.be/schema/mig/transfer/agentcommand"
    xmlns:mam="http://www.vrt.be/schema/mig/messaging/mam"
    xmlns:ebu="urn:ebu:metadata-schema:ebuCore_2012"
    xmlns:mig="http://www.vrt.be/schema/mig/messaging"
    xmlns:dc="http://purl.org/dc/elements/1.1/">
    <ns8:timestamp>2019-11-28T11:44:00.327+01:00</ns8:timestamp>
    <ns8:metadata>
        <ebu:title>
            <dc:title>titel test viaa item</dc:title>
        </ebu:title>
    </ns8:metadata>
</ns8:metadataUpdatedEvent>
```
