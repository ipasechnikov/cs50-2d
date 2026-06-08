FROM python:3.12-slim

RUN pip install --upgrade pip
RUN pip install "setuptools<70"
RUN pip install makelove

WORKDIR /game
