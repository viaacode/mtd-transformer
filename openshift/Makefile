.ONESHELL:
SHELL = /bin/bash

.PHONY: all test

test:
	pip install pipenv
	pipenv install --dev
	pipenv run pytest -vvv --cov=./src --cov=./src/transformer --junit-xml=./tests/test_results.xml