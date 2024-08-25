from flask import Flask, request, jsonify
from http import HTTPStatus
import dashscope
from dashscope import ImageSynthesis
import gridfs
from dashscope import Generation
from urllib.parse import urlparse, unquote
from pathlib import PurePosixPath
import requests
import datetime
import requests
from pymongo import MongoClient
from bson.binary import Binary

# 阿里-通义千问API Key
dashscope.api_key = 'sk-3cbef398591442da9bbab108c4a3a720'

def simple_call(prompt):
    '''根据prompt生成图片，返回对应的url'''
    # prompt = '2 birds in Van Gogh Style'
    rsp = ImageSynthesis.call(model=ImageSynthesis.Models.wanx_v1,
                              prompt=prompt,
                              n=4,
                              size='1024*1024')
    if rsp.status_code == HTTPStatus.OK:
        # print(rsp.output)
        # print(rsp.usage)
        # save file to current directory
        return rsp.output.results[0]['url']
        # for result in rsp.output.results:
        #     file_name = PurePosixPath(unquote(urlparse(result.url).path)).parts[-1]
        #     with open('./%s' % file_name, 'wb+') as f:
        #         f.write(requests.get(result.url).content)
    else:
        print('Failed, status_code: %s, code: %s, message: %s' %
              (rsp.status_code, rsp.code, rsp.message))
        return ''

# 连接到MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['image_db']

def download_to_mongodb(url):
    # 创建GridFS实例
    fs = gridfs.GridFS(db)
    # 下载图像
    response = requests.get(url)

    if response.status_code == 200:
        # 获取文件名
        filename = url.split('/')[-1]

        # 将图像存储到GridFS
        file_id = fs.put(response.content, filename=filename)

        print(f"图像已成功存储。文件ID: {file_id}")
    else:
        print("无法下载图像")

    # 关闭MongoDB连接
    client.close()
    return

# Flask API - Post Method
app = Flask(__name__)

@app.route('/gptapi', methods=['POST'])
def generate_image():
    try:
        data = request.json
        print(data)
        print('loc1')
        prompt = data.get('prompt')
        print(prompt)
        print('loc2')

        if not prompt:
            return jsonify({'error': 'No prompt provided'}), 400

        # PNG图像的URL
        url_result = simple_call(prompt)

        print(url_result, 'haha')
        # 图片存储到mongodb
        download_to_mongodb(url_result)

        return jsonify({'image_url': url_result})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
