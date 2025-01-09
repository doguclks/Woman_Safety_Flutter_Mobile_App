import pandas as pd 
import nltk
nltk.download('stopwords')
nltk.download('wordnet')
nltk.download('punkt')
nltk.download('punkt_tab')
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
import gensim
from gensim.models import Word2Vec
import numpy as np 
from sklearn.model_selection import train_test_split
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Embedding, LSTM, Dropout, Bidirectional
from tensorflow.keras.callbacks import EarlyStopping
import matplotlib.pyplot as plt





# PATH
file_path = 'C:/Users/dcalk/OneDrive/Desktop/OffensiveLanguageDetection/dataset/HateSpeechDatasetBalanced.csv'

#READ
data = pd.read_csv(file_path)
data.head()


# INFORMATION ABOUT 1 AND 0
print(data['Label'].value_counts())



# SHUFFLE DATASET
data= data.sample(frac=1, random_state=42).reset_index(drop=True)

data.head()


# CONVERT DATA TO LOWERCASE

data['Content'] = data['Content'].str.lower()


data['Content'] = data['Content'].str.strip().replace('\s+', ' ', regex=True)


# STOP WORDS
stop_words = set(stopwords.words('english'))
data['Content'] = data['Content'].apply(lambda x: ' '.join([word for word in x.split() if word not in stop_words]))

# TOKENIZATION

data['Tokens'] = data['Content'].apply(lambda x: word_tokenize(x))



# LEMMAZITATION
lemmatizer = WordNetLemmatizer()
data['Tokens'] = data['Tokens'].apply(lambda x: [lemmatizer.lemmatize(word) for word in x])


# WORD2VEC
w2v_model = Word2Vec(sentences=data['Tokens'], vector_size=100, window=5, min_count=1, sg=1, workers=4)


# AVERAGE WORD VECTORS
def average_word_vectors(tokens, model, vector_size):
    vectors = [model.wv[word] for word in tokens if word in model.wv]
    if len(vectors) == 0:
        return np.zeros(vector_size)  # Boş vektör döndür
    return np.mean(vectors, axis=0)

# Her bir metin için ortalama vektör hesaplama
data['vector'] = data['Tokens'].apply(lambda x: average_word_vectors(x, w2v_model, 100))

# Bağımsız değişkenleri ve etiketleri hazırlama
X = np.vstack(data['vector'].values)
y = data['Label'].values

# TRAIN TEST SPLIT
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# LSTM

from tensorflow.keras.optimizers import Adam
# Modeli oluşturma
model = Sequential()

model.add(Dense(64, input_shape=(X_train.shape[1],), activation='relu'))

# LSTM katmanı
model.add(Dense(64, activation='relu'))
model.add(Dropout(0.3))
model.add(Dense(32, activation='relu'))
model.add(Dropout(0.3))
model.add(Dense(1, activation='sigmoid'))

model.compile(optimizer=Adam(learning_rate=0.0001),
              loss='binary_crossentropy',
              metrics=['accuracy'])

model.summary()



# MODEL FIT 


from tensorflow.keras.callbacks import EarlyStopping
es = EarlyStopping(monitor='val_loss', patience=3, verbose=1)
# Modeli eğitme
history = model.fit(X_train, y_train,
                    validation_split=0.3,
                    epochs=20,
                    batch_size=128,
                    callbacks= [es]
                    )


# Model performansı için accuracy ve loss grafikleri
plt.plot(history.history['accuracy'], label='Train Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.legend()
plt.title('Model Accuracy')
plt.show()

plt.plot(history.history['loss'], label='Train Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.legend()
plt.title('Model Loss')
plt.show()

# Test setinde değerlendirme
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"Test Accuracy: {test_acc:.2f}")


model.save('C:/Users/dcalk/OneDrive/Desktop/OffensiveLanguageDetection/model/saved_model_yeni.h5')
w2v_model.save('C:/Users/dcalk/OneDrive/Desktop/OffensiveLanguageDetection/model/w2v_saved_model_yeni.model')



