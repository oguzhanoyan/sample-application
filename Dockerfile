FROM python:3.7

RUN pip install Flask gunicorn mysqlclient 

WORKDIR /app
COPY . .

ENV PORT 3000

CMD exec gunicorn --bind 0.0.0.0:$PORT app:application