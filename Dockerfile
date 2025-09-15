FROM python:3.10-slim AS builder
WORKDIR /project
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/training/trainer.py ./app/training/trainer.py
COPY app/training/__init__.py ./app/training/__init__.py
COPY app/__init__.py ./app/__init__.py
RUN python -m app.training.trainer
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ ./app/
COPY --from=builder /project/diabetes_model.pkl .
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]