from flask import Flask
# 实例化例子
app = Flask(__name__)
@app.route('/hello', methods = ['GET', 'POST'], endpoint =  'hello')
def hello():
    return '<h1>hello world!<h1>'
@app.route('/hello', methods = ['GET', 'POST'], endpoint = 'hi')
def hi():
    return 'hi hi'

if __name__ == '__main__':
    app.run()