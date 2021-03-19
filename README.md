# Metadate transformation service

Transforms given metadata to a new format based on a chosen transformation.


For XML-to-XML transformations Saxon HE is used under the hood. Saxon HE is (c) Michael H. Kay and released under the Mozilla MPL 1.0 (http://www.mozilla.org/MPL/1.0/)

## Prerequisites

- Python (tested with v3.8)
- Pipenv
- Saxon/C python api (make sure it's available in your PYTHONPATH)
    - [Installing Saxon/C](https://www.saxonica.com/saxon-c/documentation/index.html#!starting/installing)
    - [Building the python package](https://www.saxonica.com/saxon-c/documentation/index.html#!starting/installingpython)
    - Adding it to your PYTHONPATH, for example using: `export PYTHONPATH=~/Downloads/Saxonica/SaxonHEC1.2.1/Saxon.C.API/python-saxon` (Depends on your OS and install location)


## Installation

1. Clone or download the repository
2. `cd` into the directory
3. Create a virtual environment and install dependencies using `pipenv install`

## Usage

### CLI

Coming soon

### API

Run `pipenv run uwsgi -i uwsgi.ini` to start the service.

#### Example

To transform an XML-file, send a `POST` request to `http://0.0.0.0:8080/transform?transformation=OR-rf5kf25` with the xml in the body.
Add `application/xml` to the `Content-Type` header.

HTTP-call:
```HTTP
POST /v1/transform?transformation=OR-rf5kf25 HTTP/1.1
Host: 0.0.0.0:8080
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
