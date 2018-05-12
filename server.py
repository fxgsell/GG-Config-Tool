import os
import sys
from flask import Flask, request
from werkzeug.utils import secure_filename

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

@app.route('/configure-certificates', methods=['POST'])
def handle_certificates():
    if 'certificates' not in request.files:
        print('No certificates')
        return app.send_static_file('index.html')
    file = request.files['certificates']
    if file.filename == '':
        print('No selected file')
        return app.send_static_file('index.html')

    if file and file.filename.endswith('.tar.gz'):
        print('Saving to uploads/certificates.tar.gz')
        file.save('uploads/certificates.tar.gz')
    return app.send_static_file('index.html')

if __name__ == "__main__":
    app.run(host= '0.0.0.0', port=80)
    
