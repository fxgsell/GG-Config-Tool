import os
import sys
from flask import Flask, request
from werkzeug.utils import secure_filename

ALLOWED_EXTENSIONS = set(['tar.gz'])

app = Flask(__name__) 
app._static_folder='.'

app.config['UPLOAD_FOLDER'] = './uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

if not os.path.exists(app.config['UPLOAD_FOLDER']):
    os.makedirs(app.config['UPLOAD_FOLDER'])

def shutdown_server():
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()

@app.route('/', methods=['GET'])
def root():
    return app.send_static_file('index.html')

@app.route('/finished', methods=['GET'])
def shutdown():
    shutdown_server()
    return 'Restarting...'

@app.route('/configure-wifi', methods=['POST'])
def handle_wifi():
    print(request)
    if request.method == 'POST':
        form = request.form
        if 'networkName' in form or 'networkPassword' in form:
            network = request.form['networkName']
            password = request.form['networkPassword']
            print('Updating Wifi to: ', network)
        
    return app.send_static_file('index.html')

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/configure-certificates', methods=['POST'])
def handle_certificates():
    print(request.files)
    if 'certificates' not in request.files:
        print('No certificates')
        return app.send_static_file('index.html')
    file = request.files['certificates']
    # if user does not select file, browser also
    # submit a empty part without filename
    if file.filename == '':
        print('No selected file')
        return app.send_static_file('index.html')
    if file and allowed_file(file.filename):
        #filename = secure_filename(file.filename)
        filename = 'certificates.zip'
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename ))
    return app.send_static_file('index.html')

if __name__ == "__main__":
    app.run(host= '0.0.0.0', port=5000)
    
