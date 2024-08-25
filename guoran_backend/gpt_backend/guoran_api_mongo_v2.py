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

import mysql.connector
from pymongo import MongoClient
import datetime

# MySQL连接
mysql_conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="yourpassword",
    database="guoran"
)
mysql_cursor = mysql_conn.cursor()

# MongoDB连接
mongo_client = MongoClient("mongodb://localhost:27017/")
mongo_db = mongo_client["image_db"]
images_collection = mongo_db["images"]
comments_collection = mongo_db["comments"]

# 发布帖子示例
def create_post(user_id, caption, image_url):
    # 插入MySQL帖子数据
    mysql_cursor.execute("INSERT INTO posts (user_id, caption, created_at) VALUES (%s, %s, %s)", (user_id, caption, datetime.datetime.now()))
    post_id = mysql_cursor.lastrowid
    mysql_conn.commit()

    # 插入MongoDB图片数据
    image_data = {
        "user_id": user_id,
        "post_id": post_id,
        "image_url": image_url,
        "created_at": datetime.datetime.now()
    }
    images_collection.insert_one(image_data)

    return post_id

# 读取帖子示例
def get_post(post_id):
    # 从MySQL读取帖子数据
    mysql_cursor.execute("SELECT * FROM posts WHERE post_id = %s", (post_id,))
    post_data = mysql_cursor.fetchone()

    # 从MongoDB读取图片数据
    image_data = images_collection.find_one({"post_id": post_id})

    post = {
        "post_id": post_data[0],
        "user_id": post_data[1],
        "caption": post_data[2],
        "created_at": post_data[3],
        "image_url": image_data["image_url"]
    }

    return post

# 示例调用
post_id = create_post(1, "My first post!", "https://dashscope-result-hz.oss-cn-hangzhou.aliyuncs.com/1d/fb/20240714/522176a8/8d0ed6a5-ef85-4248-9afb-4b9d614979b9-1.png?Expires=1721016863&OSSAccessKeyId=LTAI5tQZd8AEcZX6KZV4G8qL&Signature=Uj%2BWZn2tA4VGZnlHKnMpjvj7w%2FM%3D")
post = get_post(post_id)
print(post)


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
