# Use Python Alpine base image
FROM python:3.9-alpine

# Set working directory
WORKDIR /app

# Install dependencies for pip (since alpine is minimal)
RUN apk add --no-cache gcc musl-dev linux-headers

# Copy app files
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose port
EXPOSE 5000

# Run the app
CMD ["python", "app.py", "--port=80", "--host=0.0.0.0"]
