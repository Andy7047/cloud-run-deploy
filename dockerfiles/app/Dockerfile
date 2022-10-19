# syntax=docker/dockerfile:1

ARG _REPOSITORY
ARG _TAG

FROM ${_REPOSITORY}/${_BASE_SERVICE_NAME}:$_TAG

ENV CloudAccountType gcp
ENV ACCOUNT_TYPE gcp

ADD ./dockerfiles/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ENV AIBLE_HOME /aible
WORKDIR $AIBLE_HOME

ADD ./dockerfiles/init.sh init.sh
RUN chmod +x init.sh
ADD ./dockerfiles/get_notebooks.py get_notebooks.py

CMD exec $AIBLE_HOME/init.sh --port :$PORT --app aible_app:flask_app --timeout 180
