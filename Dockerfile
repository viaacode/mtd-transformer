FROM python:3.8-slim-buster

# Applications should run on port 8080 so NGINX can auto discover them.
EXPOSE 8080

# Make a new group and user so we don't run as root.
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

WORKDIR /app

# Let the appuser own the files so he can rwx during runtime.
COPY . .
RUN chown -R appuser:appgroup /app

# The -slim variant of the python package purges the man-pages directory, 
# but it is needed to install java.
RUN mkdir /usr/share/man/man1/ 

# Install gcc and libc6-dev to be able to compile uWSGI
RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc libc6-dev default-jre-headless && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# We install all our Python dependencies. 
RUN pip3 install pipenv
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy --system

USER appuser

# This command will be run when starting the container. It is the same one that
# can be used to run the application locally.
ENTRYPOINT ["uwsgi", "-i", "uwsgi.ini"]
