# Create API of ML model using flask

'''
This code takes the JSON data while POST request an performs the prediction using loaded model and returns
the results in JSON format.
'''

# Import libraries
import numpy as np
from flask import Flask, render_template, request, jsonify
import pickle

app = Flask(__name__)

# Load the model
model = pickle.load(open('./model/LRmodel.pkl','rb'))

@app.route('/')
def home():
    return render_template("index.html")


@app.route('/predict',methods=['POST'])
def predict():
    # Get the data from the POST request.
    if request.method == "POST":
        #data = request.get_json(force=True)
        modelInput = []
        print(request.form['exp'])
        data = float(request.form['AQI'])
        modelInput.append(data)
        data = request.form['heavy_rain']
        if data == "yes":
            newdata = 1
        elif data == "no":
            newdata = 0
        modelInput.append(newdata)
        data = request.form['high_wind']
        if data == "yes":
            newdata = 1
        elif data == "no":
            newdata = 0 
        modelInput.append(newdata)
        data = float(request.form['Year'])
        modelInput.append(data)
        data = float(request.form['Population'])
        modelInput.append(data)
        data = request.form['counties_num']
        if data == "Orange":
            newdata = 7
        elif data == "Ventura":
            newdata = 11 
        elif data == "Los Angeles":
            newdata = 28 
        elif data == "Sacramento":
            newdata = 27 
        elif data == "Santa Barbara":
            newdata = 29
        elif data == "San Diego":
            newdata = 2 
        elif data == "Kern":
            newdata = 1  
        modelInput.append(newdata)
        modelInput.append(1)
        data = request.form['season_num']
        if data == "spring":
            newdata = 1
        elif data == "autumn":
            newdata = 2
        elif data == "winter":
            newdata = 3
        elif data == "summer":
            newdata = 4
        modelInput.append(newdata)
        
        
        print (modelInput)
        print("Data", model.predict([modelInput]))
        # Make prediction using model loaded from disk as per the data.
        prediction = model.predict([modelInput])

        # Take the first value of prediction
        output = prediction[0]
        if output == 1:
            label = "Calypte anna"
        elif output == 2:
            label = "Selasphorus sasin"
        elif output == 3:
            label = "Calypte costae"
        elif output == 4:
            label = "Selasphorus rufus"
        elif output == 5:
            label = "Archilochus alexandri"
        elif output == 6:
            label = "Selasphorus calliope"
        elif output == 7:
            label = "Cynanthus latirostris"
        elif output == 8:
            label = "Selasphorus platycercus"
        elif output == 9:
            label = "Archilochus colubris"
        elif output == 10:
            label = "Amazilia violiceps"

        return render_template("results.html", output=label, exp=data)

if __name__ == '__main__':
    app.run(debug=True)
