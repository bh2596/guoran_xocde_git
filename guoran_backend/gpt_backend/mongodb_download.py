from pymongo import MongoClient
from gridfs import GridFS
from bson.objectid import ObjectId
# 连接到MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['image_db']

def download_file_by_id(file_id, output_path):
    # # 连接到 MongoDB
    # client = MongoClient('mongodb://localhost:27017/')  # 替换为你的 MongoDB 连接字符串
    # db = client[db_name]

    # 创建 GridFS 实例
    fs = GridFS(db)

    try:
        # 通过 file_id 查找文件
        file_id_obj = ObjectId(file_id)
        file_data = fs.get(file_id_obj)

        # 将文件内容写入到输出路径
        with open(output_path, 'wb') as output_file:
            output_file.write(file_data.read())

        print(f"File successfully downloaded to {output_path}")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # 关闭连接
        client.close()


# 使用示例
file_id = "66896d2e89fbb2b39107e1f1"  # 替换为实际的文件 ID
output_path = "data/downloaded_file1.png"  # 下载文件的保存路径

download_file_by_id(file_id, output_path)