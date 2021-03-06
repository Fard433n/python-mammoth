.PHONY: test upload clean bootstrap setup

test:
	_virtualenv/bin/pyflakes mammoth tests
	sh -c '. _virtualenv/bin/activate; nosetests tests'

test-all:
	tox

upload: setup assert-converted-readme
	_virtualenv/bin/python setup.py sdist bdist_wheel upload
	make clean

register: setup
	python setup.py register

README: README.md
	pandoc --from=markdown --to=rst README.md > README || cp README.md README

assert-converted-readme:
	test "`cat README`" != "`cat README.md`"

clean:
	rm -f README
	rm -f MANIFEST
	rm -rf dist

bootstrap: _virtualenv setup
	_virtualenv/bin/pip install -e .
ifneq ($(wildcard test-requirements.txt),)
	_virtualenv/bin/pip install -r test-requirements.txt
endif
	make clean

setup: README

_virtualenv:
	python3 -m venv _virtualenv
	_virtualenv/bin/pip install --upgrade pip
	_virtualenv/bin/pip install --upgrade setuptools
	_virtualenv/bin/pip install --upgrade wheel
