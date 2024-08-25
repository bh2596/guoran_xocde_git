from flask import Flask, request, jsonify
import requests

app = Flask(__name__)


@app.route('/generate-image', methods=['POST'])
def generate_image():
    # 从请求中获取图片生成的参数
    content = request.json
    prompt = content.get('prompt', '默认的图片描述')

    # 调用 GPT 图片生成 API
    response = requests.post(
        'https://api.example.com/generate-image',  # 替换成实际的API URL
        json={'prompt': prompt}
    )
    image_data = response.json()

    # 假设返回的数据中包含图片的链接
    image_url = image_data.get('url')

    # 返回图片链接给前端
    return jsonify({'image_url': image_url})


if __name__ == '__main__':
    app.run(debug=True)
