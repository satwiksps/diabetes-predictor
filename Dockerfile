# --- Stage 1: Builder ---
# This stage builds the model file
FROM python:3.10-slim AS builder

WORKDIR /project

# Install dependencies needed for training
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the training code
# We need the __init__ files to run as a module
COPY app/training/trainer.py ./app/training/trainer.py
COPY app/training/__init__.py ./app/training/__init__.py
COPY app/__init__.py ./app/__init__.py

# Run the training script to generate the model
# This saves diabetes_model.pkl in the /project directory
RUN python -m app.training.trainer


# --- Stage 2: Final Application ---
# This stage builds the final, lightweight production image
FROM python:3.10-slim

WORKDIR /app

# Install runtime dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code from the current directory
# We only copy what's needed for the API
COPY app/main.py .
COPY app/model.py .
COPY app/schema.py .
COPY app/__init__.py .

# Copy the trained model from the 'builder' stage
COPY --from=builder /project/diabetes_model.pkl .

# Expose the port the app runs on
EXPOSE 8000

# Run the FastAPI app with Uvicorn
# We run 'app.main:app' because our main.py is inside the 'app' package
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]