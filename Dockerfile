FROM python:3.8-slim
ARG DEBIAN_FRONTEND=noninteractive

# edit this to use a different version of Saxon
ARG saxon='libsaxon-HEC-setup64-v1.2.1'

# Applications should run on port 8080 so NGINX can auto discover them.
EXPOSE 8080

# Make a new group and user so we don't run as root.
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

WORKDIR /app

# Let the appuser own the files so he can rwx during runtime.
COPY . .
RUN chown -R appuser:appgroup /app

# Install gcc and libc6-dev to be able to compile uWSGI
RUN apt-get update && \
    apt-get install --no-install-recommends -y unzip curl gcc g++ libc6-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download saxon
RUN curl https://www.saxonica.com/saxon-c/${saxon}.zip --output saxon.zip

# Install Saxon
RUN unzip saxon.zip -d saxon &&\
    saxon/${saxon} -batch -dest /opt/saxon &&\
    ln -s /opt/saxon/libsaxonhec.so /usr/lib/ &&\
    ln -s /opt/saxon/rt /usr/lib/

# We install all our Python dependencies. 
RUN pip3 install pipenv
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy --system

# Build the saxon python module and add it to pythonpath.
WORKDIR /opt/saxon/Saxon.C.API/python-saxon
RUN python3 saxon-setup.py build_ext -if
ENV PYTHONPATH "${PYTHONPATH}:/opt/saxon/Saxon.C.API/python-saxon/"

WORKDIR /app
USER appuser

# This command will be run when starting the container. It is the same one that
# can be used to run the application locally.
ENTRYPOINT ["uwsgi", "-i", "uwsgi.ini"]
