FROM python:3.8

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt --extra-index-url http://do-prd-mvn-01.do.viaa.be:8081/repository/pypi-all/simple --trusted-host do-prd-mvn-01.do.viaa.be
RUN chmod 775 .

# install java, needed for saxon
RUN apt update \
&& apt install -y default-jre \
&& rm -rf /var/lib/apt

EXPOSE 5000
CMD [ "python", "app.py" ]
