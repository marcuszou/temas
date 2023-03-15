# Base image
FROM python:3.10.6-slim
LABEL maintainer="https://github.com/marcuszou/"

# Update, install cron and some utilities
RUN apt-get update && apt-get install cron nano procps -y
# /usr/sbin/service cron start
RUN pip install --upgrade pip

# Copy the cron job that runs the Python script every hour
COPY mycrontab /etc/cron.d/mycrontab
RUN touch /var/log/cron.log
RUN chmod +x /etc/cron.d/mycrontab
RUN crontab /etc/cron.d/mycrontab

# Copy files to work directory
WORKDIR /app
COPY . /app
# Install Python libraries in the WORKDIR!
RUN pip install -r requirements.txt

# Expose port 8000 for the http.server
EXPOSE 8000

# Run cron daemon and Launch the webserver - http.server
CMD cron && python -m http.server 8000