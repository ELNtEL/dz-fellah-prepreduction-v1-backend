# Force rebuild - v3
FROM python:3.12
WORKDIR /usr/local/dzfellah

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt ./requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p logs staticfiles media

# Collect static files (for production)
RUN python manage.py collectstatic --noinput || true

# Expose port (Railway will set PORT env variable)
EXPOSE 8000

# Create startup script
RUN echo '#!/bin/sh\n\
echo "Running migrations..."\n\
python manage.py migrate --noinput\n\
echo "Creating superuser if needed..."\n\
python manage.py createadmin\n\
echo "Starting gunicorn..."\n\
exec gunicorn config.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers 2 --timeout 120 --access-logfile - --error-logfile -\n\
' > /start.sh && chmod +x /start.sh

# Use startup script
CMD ["/start.sh"]