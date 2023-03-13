# Base image
FROM python:3.10.6-slim
LABEL maintainer="https://github.com/marcuszou/"

# Update, install cron
RUN apt-get update && apt-get install cron -y

# Copy files to work directory
WORKDIR /app
COPY . /app
# Install Python libraries
RUN pip install -r requirements.txt

# Create a cron job that runs the Python script every hour
RUN echo "*/5 * * * * python /app/app-updater.py >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycrontab

# Expose port 8000 for the http.server
EXPOSE 8000

# Set the command to run the http.server
CMD python -m http.server