from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
import json


import re
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

# Stop words ve lemmatizer başlatma
stop_words = set(stopwords.words("english"))  # İngilizce için durdurma kelimeleri
lemmatizer = WordNetLemmatizer()

def preprocess_text(text):
    """Metni temizlemek ve ön işleme adımlarını uygulamak."""
    # 1. Küçük harfe çevir
    text = text.lower()
    
    # 2. Noktalama işaretlerini kaldır
    text = re.sub(r'[^\w\s]', '', text)
    
    # 3. Sayıları kaldır
    text = re.sub(r'\d+', '', text)
    
    # 4. Stop words kaldır
    words = text.split()
    words = [word for word in words if word not in stop_words]
    
    # 5. Kelimeleri köklerine indir (lemmatization)
    words = [lemmatizer.lemmatize(word) for word in words]
    
    # 6. Kelimeleri birleştir
    text = ' '.join(words)
    
    return text


# Flask uygulamasını başlat
app = Flask(__name__)
CORS(app)  # CORS'u etkinleştir

# Model ve yardımcı dosyaları yükle
model = tf.keras.models.load_model("C:/Users/dcalk/OneDrive/Desktop/OffensiveLanguageDetection/model/saved_model_yeni.h5")
with open("C:/Users/dcalk/OneDrive/Desktop/OffensiveLanguageDetection/model/word2vec_yeni.json", "r") as f:
    word2vec = json.load(f)
def text_to_vector(text):
    """Metni vektöre çeviren yardımcı fonksiyon."""
    words = text.lower().split()
    vector = np.zeros(100)  # Vektör boyutunu embedding boyutuna göre ayarlayın
    for word in words:
        if word in word2vec:
            vector += np.array(word2vec[word])
    return vector.reshape(1, -1)
@app.route('/')
def home():
    return "Offensive Language Detection API is running."

@app.route('/predict', methods=['GET', 'POST'])
def predict():
    if request.method == 'GET':
        return "Use POST to send text data for prediction."
    try:
        data = request.get_json()
        text = data.get("text", "")
        
        # Ön işleme adımını uygula
        preprocessed_text = preprocess_text(text)
        
        # Metni vektöre çevir
        vector = text_to_vector(preprocessed_text)
        
        # Model ile tahmin yap
        prediction = model.predict(vector)
        result = "Offensive" if prediction[0][0] > 0.5 else "Normal"
        
        return jsonify({"prediction": result, "score": float(prediction[0][0])})
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == "__main__":
    app.run(debug=True, use_reloader=False, host="0.0.0.0", port=5000)

