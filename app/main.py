from fastapi import FastAPI
from .schema import DiabetesInput
from .model import load_model, predict_diabetes

app = FastAPI(
    title="Diabetes Prediction API",
    description="An API to predict diabetes based on health data.",
    version="1.0.0"
)

# This will load the model when the app starts
model = load_model()

@app.get("/", tags=["Health"])
def read_root():
    return {"message": "Diabetes Prediction API is running"}

@app.post("/predict", tags=["Prediction"])
def predict(input_data: DiabetesInput):
    """
    Predicts diabetes based on input features.
    
    Returns:
    - `diabetic`: boolean (true if diabetic, false otherwise)
    """
    prediction = predict_diabetes(model, input_data)
    return {"diabetic": prediction}