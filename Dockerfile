FROM python:3.8
ARG DEBIAN_FRONTEND=noninteractive

# Applications should run on port 8080 so NGINX can auto discover them.
EXPOSE 8080

# Make a new group and user so we don't run as root.
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

WORKDIR /app

# Let the appuser own the files so he can rwx during runtime.
COPY . .
RUN chown -R appuser:appgroup /app

# We install all our Python dependencies. 
RUN pip3 install -r requirements.txt \
    --extra-index-url http://do-prd-mvn-01.do.viaa.be:8081/repository/pypi-all/simple \
    --trusted-host do-prd-mvn-01.do.viaa.be

WORKDIR /app
USER appuser

# This command will be run when starting the container. It is the same one that
# can be used to run the application locally.
ENTRYPOINT ["uwsgi", "-i", "uwsgi.ini"]
