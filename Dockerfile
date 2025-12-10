FROM python:3.12
WORKDIR /usr/local/dzfellah

COPY requirements.txt ./requirements.txt


# db Postgres
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# installer depencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# pour executer le server directement
# CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]