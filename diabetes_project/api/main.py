# إطار عمل لبناء تطبيقات الويب في Python (لإنشاء واجهة برمجة التطبيقات API)
from flask import Flask, request, jsonify
# لمعالجة وتحليل البيانات (قراءة ملف CSV ومعالجة البيانات)
import pandas as pd
#  للحسابات العلمية (معالجة المصفوفات)
import numpy as np
import os
import socket
from datetime import datetime
# //  لتعلم الآلة (بناء وتدريب نموذج التنبؤ)
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
# //لحفظ وتحميل النماذج المدربة
import joblib

app = Flask(__name__)

# Load and preprocess diabetes data
def load_diabetes_data(csv_path):
    diabetes_data = pd.read_csv(csv_path)
    
    # Preprocessing steps
    # Separate features and target
    X = diabetes_data.drop('Outcome', axis=1)
    y = diabetes_data['Outcome']
    
    # Split data (you might want to do this once and save the model)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    return X_train, X_test, y_train, y_test

# Train or load diabetes prediction model
def load_model(model_path=None, data_path=None):
    if model_path and os.path.exists(model_path):
        # Load pre-trained model
        model = joblib.load(model_path)
    elif data_path:
        # Train new model (only do this in development)
        X_train, _, y_train, _ = load_diabetes_data(data_path)
        model = RandomForestClassifier(n_estimators=100, random_state=42)
        model.fit(X_train, y_train)
        
        # Save the model for future use
        if model_path:
            joblib.dump(model, model_path)
    else:
        raise ValueError("Either model_path or data_path must be provided")
    
    return model

# Make prediction from input features
def make_prediction(model, input_features):
    # Convert input features to numpy array
    features = np.array(input_features).reshape(1, -1)
    
    # Make prediction
    prediction = model.predict(features)
    probability = model.predict_proba(features)[0][1]  # Probability of diabetes
    
    return {
        "prediction": int(prediction[0]),
        "probability": float(probability),
        "features": input_features
    }

@app.errorhandler(Exception)
def handle_exception(e):
    return jsonify({'error': str(e)}), 500
def get_diabetes_advice(prediction, probability, features):
    """Generate personalized medical advice based on diabetes prediction results"""
    advice = {}
    
    # Validate input parameters
    if not isinstance(features, list) or len(features) != 8:
        raise ValueError("Features must be a list of 8 numerical values")
    
    if not 0 <= probability <= 1:
        raise ValueError("Probability must be between 0 and 1")
    
    if prediction not in [0, 1]:
        raise ValueError("Prediction must be 0 or 1")
    
    # Extract relevant features with error handling
    try:
        glucose_level = features[1]
        bmi = features[5]
        age = features[7]
        pregnancies = features[0]
    except (IndexError, TypeError) as e:
        raise ValueError(f"Invalid features format: {str(e)}")

    # High risk case (confirmed diabetes)
    if prediction == 1 and probability >= 0.7:
        advice = {
            "status": "خطر عالي",
            "advice": "نتيجة الفحص تشير إلى احتمال إصابة عالي بالسكري، ننصح بمراجعة الطبيب فوراً",
            "immediate_actions": [
                "مراجعة طبيب الغدد الصماء خلال 48 ساعة",
                "إجراء فحص HbA1c لتأكيد التشخيص",
                "قياس السكر 4 مرات يومياً (قبل الوجبات وقبل النوم)"
            ],
            "treatment_plan": {
                "diet": [
                    "نظام غذائي منخفض الكربوهيدرات (لا يزيد عن 50 جرام يومياً)",
                    "تناول 5-6 وجبات صغيرة يومياً",
                    "التركيز على الخضروات الورقية والبروتينات الصحية"
                ],
                "medication": [
                    "الميتفورمين كخط علاج أول (حسب وصف الطبيب)",
                    "قد يحتاج المريض للإنسولين إذا كان السكر أعلى من 300 ملغ/دل"
                ],
                "exercise": [
                    "30 دقيقة مشي يومياً",
                    "تمارين مقاومة 3 مرات أسبوعياً"
                ]
            },
            "prohibitions": [
                "السكريات المكررة والعصائر المحلاة",
                "الدهون المشبعة والمقليات",
                "التدخين والكحول",
                "الجلوس لفترات طويلة دون حركة"
            ],
            "monitoring": [
                "فحص القدمين يومياً لملاحظة أي جروح",
                "قياس ضغط الدم أسبوعياً",
                "فحص العيون سنوياً"
            ]
        }
    
    # Medium risk case (pre-diabetes or high glucose)
    elif (prediction == 1 and probability >= 0.4) or (glucose_level > 140):
        advice = {
            "status": "خطر متوسط",
            "advice": "هناك مؤشرات لبداية الإصابة أو مقدمات السكري",
            "immediate_actions": [
                "مراجعة الطبيب خلال أسبوع",
                "إجراء فحص تحمل الجلوكوز",
                "قياس السكر يومياً قبل الفطور وبعد العشاء"
            ],
            "treatment_plan": {
                "diet": [
                    "تقليل الكربوهيدرات إلى 100-150 جرام يومياً",
                    "تناول الألياف الغذائية (30 جرام يومياً)",
                    "شرب 2 لتر ماء يومياً"
                ],
                "medication": [
                    "قد يوصي الطبيب بالميتفورمين للوقاية",
                    "مكملات فيتامين د إذا كان هناك نقص"
                ],
                "exercise": [
                    "150 دقيقة نشاط أسبوعياً",
                    "تمارين اليوجا لتقليل التوتر"
                ]
            },
            "prohibitions": [
                "الأطعمة ذات المؤشر الجلايسيمي العالي",
                "المشروبات الغازية حتى الدايت",
                "الوجبات السريعة"
            ],
            "monitoring": [
                "فحص السكر أسبوعياً",
                "قياس الوزن شهرياً",
                "فحص الكوليسترول كل 6 أشهر"
            ]
        }
    
    # Low risk case
    else:
        advice = {
            "status": "خطر منخفض",
            "advice": "لا توجد مؤشرات قوية للإصابة ولكن ننصح بالوقاية",
            "prevention_plan": {
                "diet": [
                    "نظام غذائي متوازن (طبق الصحّة)",
                    "تناول المكسرات النيئة بكميات معتدلة",
                    "استبدال السكر ببدائل طبيعية مثل القرفة"
                ],
                "lifestyle": [
                    "7-8 ساعات نوم يومياً",
                    "إدارة التوتر بتقنيات التنفس",
                    "الحفاظ على وزن صحي (مؤشر كتلة الجسم 18-25)"
                ],
                "checkups": [
                    "فحص السكر سنوياً بعد عمر 40",
                    "قياس محيط الخصر شهرياً (أقل من 90 سم للرجال، 80 سم للنساء)"
                ]
            },
            "general_advice": [
                "المشي بعد الوجبات الرئيسية",
                "تناول خل التفاح المخفف قبل الوجبات",
                "تعريض الجسم لأشعة الشمس الصباحية"
            ]
        }
    
    # Age-specific advice
    if age > 50:
        advice["age_advice"] = [
            "فحص وظائف الكلى سنوياً",
            "مراقبة ضغط الدم بانتظام",
            "تناول الأطعمة الغنية بأوميغا-3"
        ]
    
    # Pregnancy-specific advice
    if pregnancies > 0:  # If there were previous pregnancies
        advice["pregnancy_advice"] = [
            "فحص سكر الحمل في أي حمل قادم",
            "الرضاعة الطبيعية تقلل خطر السكري"
        ]
    
    return advice

@app.route("/predict", methods=["POST"])
def predict():
    """Endpoint for diabetes prediction with medical advice"""
    start_time = datetime.now()
    
    try:
        # Validate and parse input
        data = request.get_json()
        
        if not data or 'features' not in data:
            return jsonify({"error": "No features provided in request"}), 400
        
        features = data['features']
        
        if len(features) != 8:
            return jsonify({"error": "Expected 8 features for diabetes prediction"}), 400
        
        # Load model
        script_dir = os.path.dirname(os.path.abspath(__file__))
        model_path = os.path.join(script_dir, "diabetes_model.pkl")
        data_path = os.path.join(script_dir, "diabetes.csv")
        
        model = load_model(model_path=model_path, data_path=data_path)
        
        # Make prediction
        prediction_result = make_prediction(model, features)
        prediction = prediction_result["prediction"]
        probability = prediction_result["probability"]
        
        # Generate medical advice
        medical_advice = get_diabetes_advice(prediction, probability, features)
        
        # Prepare response
        response = {
            "prediction": int(prediction),
            "probability": float(probability),
            "medical_advice": medical_advice,
            "features": features,
            "processing_time_ms": (datetime.now() - start_time).total_seconds() * 1000,
            "timestamp": datetime.now().isoformat()
        }
        
        return jsonify(response)

    except ValueError as e:
        app.logger.error(f'Validation error in /predict: {str(e)}')
        return jsonify({'error': str(e)}), 400
        
    except Exception as e:
        app.logger.error(f'Unexpected error in /predict: {str(e)}')
        return jsonify({'error': 'An unexpected error occurred'}), 500
    
def get_local_ip():
    """Get the local IP address"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Doesn't need to be reachable
        s.connect(('192.168.8.249', 1))
        ip = s.getsockname()[0]
    except Exception:
        ip = '127.0.0.1'
    finally:
        s.close()
    return ip



    
if __name__ == "__main__":
    host_ip = get_local_ip()
    port = 5000
    app.run(host=host_ip, port=port, debug=True)

  
