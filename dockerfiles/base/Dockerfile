# TODO: base dockerfile across platforms. 
# The specific cloud infrastructure layer for initialization and handlers is added as a final layer to the base. 
# Additional requirements.txt is required for platform specific packages. 
# separate docker images need to be created for API and Exec as these support different routes and require different libraries

FROM python:3.7.13-slim

RUN apt-get update && apt-get install libgomp1

ENV PYTHONUNBUFFERED True

RUN pip install --upgrade pip

ADD ./dockerfiles/base/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
