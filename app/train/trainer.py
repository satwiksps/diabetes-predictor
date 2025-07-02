import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
import joblib
import os

# Define the path to save the model (at the project root)
MODEL_PATH = "diabetes_model.pkl"

def train_and_save_model(model_path: str = MODEL_PATH) -> None:
    """
    Trains a RandomForest model on diabetes dataset and saves it to disk.
    """

    # Load dataset
    url = "https://raw.githubusercontent.com/plotly/datasets/master/diabetes.csv"
    df = pd.read_csv(url)
    print("Loaded dataset with columns:", df.columns.tolist())

    # Select features and label
    features = ["Pregnancies", "Glucose", "BloodPressure", "BMI", "Age"]
    target = "Outcome"
    X = df[features]
    y = df[target]

    # Train-test split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train model
    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    # Save the model
    joblib.dump(model, model_path)
    print(f"✅ Model trained and saved to {model_path}")

if __name__ == "__main__":
    # This allows the script to be run directly
    train_and_save_model()