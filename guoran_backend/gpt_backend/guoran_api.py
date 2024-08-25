from flask import Flask, request, jsonify
import requests
from http import HTTPStatus
import dashscope
from dashscope import Generation
from urllib.parse import urlparse, unquote
from pathlib import PurePosixPath
import requests
from dashscope import ImageSynthesis
import datetime

dashscope.api_key = 'sk-3cbef398591442da9bbab108c4a3a720'


def simple_call(prompt):
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


import os

app = Flask(__name__)

# Replace 'YOUR_DALLE_API_KEY' with your actual DALL-E API key
# DALLE_API_KEY = 'YOUR_DALLE_API_KEY'
# DALLE_API_URL = 'https://api.openai.com/v1/images/generations'

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

        # headers = {
        #     'Authorization': f'Bearer {DALLE_API_KEY}',
        #     'Content-Type': 'application/json'
        # }
        #
        # payload = {
        #     'prompt': prompt,
        #     'n': 1,
        #     'size': '1024x1024'
        # }

        url_result = simple_call(prompt)
        # response = requests.post(DALLE_API_URL, headers=headers, json=payload)
        # response_data = response.json()
        #
        # if response.status_code != 200:
        #     return jsonify({'error': response_data}), response.status_code
        print(url_result, 'haha')


        return jsonify({'image_url': url_result})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
