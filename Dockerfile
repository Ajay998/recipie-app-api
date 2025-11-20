FROM python:3.13-alpine3.20
LABEL maintainer="ajaydev1998"

# Prevent Python from buffering stdout/stderr
ENV PYTHONUNBUFFERED=1

# Copy requirements first (for better layer caching)
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements-dev.txt /tmp/requirements-dev.txt

ARG DEV=false
# Set up a virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install --default-timeout=100 --retries=5 -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ] ; then /py/bin/pip install --default-timeout=100 --retries=5 -r /tmp/requirements-dev.txt ; fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Copy application code
COPY ./app /app
COPY ./manage.py /app/manage.py

# Set work directory
WORKDIR /app

# Expose port 8000
EXPOSE 8000

# Use venv's Python by default
ENV PATH="/py/bin:$PATH"

# Run as non-root user
USER django-user