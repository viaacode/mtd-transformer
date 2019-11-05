# Metadate transformation service

Transforms given metadata to a new format based on CP-id.

For XML-to-XML transformations Saxon HE is used under the hood. Saxon HE is (c) Michael H. Kay and released under the Mozilla MPL 1.0 (http://www.mozilla.org/MPL/1.0/)

## Prerequisites

- Python 3.7
- Java (for running Saxon HE)

## Installation

1. Clone or download the repository
2. `cd` into the directory
3. Create a virtual environment `python -m venv .`
4. Activate the environment `source bin/activate` on Linux or `Scripts/activate` on Windows.
5. Install dependencies `pip install -r requirements.txt`

## Usage

### Starting the service

Run `python app.py`

### Using the service

To transform an XML-file, send a `POST` request to `http://0.0.0.0:5000/transform` with following body:

```json
{
    "cp_id": "OR-id",
    "xml": "<?xml version='1.0' encoding='UTF-8' standalone='yes'?> <metadataUpdatedEvent> <timestamp>2019-10-22T20:04:00.335+02:00</timestamp> <metadata> </metadata> </metadataUpdatedEvent>"
}

```
