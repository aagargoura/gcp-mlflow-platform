FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN pip install --no-cache-dir \
    mlflow==3.1.0 \
    psycopg2-binary \
    google-cloud-storage

EXPOSE 8080

CMD ["mlflow", "--version"]