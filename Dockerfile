FROM python:3.7.3-stretch

## Step 1:
# Create a working directory
RUN mkdir -p /app

## Step 2:
# Copy source code to working directory
COPY ./app /app

## Step 3:
# Install packages from requirements.txt
RUN pip install -r /app/requirements.txt
# hadolint ignore=DL3013

## Step 4:
# Expose port 80
EXPOSE 80

## Step 5:
# Run app.py at container launch
CMD ["bash", "-c", "cd /app && python app.py"]