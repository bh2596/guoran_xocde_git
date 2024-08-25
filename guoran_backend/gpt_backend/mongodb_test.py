from pymongo import MongoClient
import gridfs
# import os

# # 获取当前文件的绝对路径
# current_file_path = os.path.abspath(__file__)
#
# print(f"Current file path: {current_file_path}")


# 连接到 MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['image_db']
fs = gridfs.GridFS(db)
# file_path = 'image1.png'
# image_name = 'mongodb_test1.png'
# output_path = 'image1_new.png'
# 存储图片
def upload_image(file_path, image_name):
    with open(file_path, 'rb') as f:
        fs.put(f, filename=image_name)

# 下载图片
def download_image(image_name, output_path):
    grid_out = fs.find_one({'filename': image_name})
    if grid_out:
        with open(output_path, 'wb') as f:
            f.write(grid_out.read())

# 看一下冷库、热库的使用，以及是否需要分布式存储

# # 示例使用
upload_image('data/image2.png', 'mongodb_test2.png')
download_image('mongodb_test2.png', 'data/image2_copy.png')
# 列出所有文件
print("Files stored in GridFS:")
for grid_out in fs.find():
    print(f"- {grid_out.filename}")
