FROM python:3.8

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt
RUN chmod 775 .

# install java, needed for saxon
RUN apt update
RUN apt install -y default-jre
RUN java -version

EXPOSE 5000
CMD [ "python", "app.py" ]
