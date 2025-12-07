FROM python:3.12
WORKDIR /usr/local/dzfellah

COPY requirements.txt ./requirements.txt


# db Postgres
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*