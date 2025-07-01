import socket
import struct
import cv2
import numpy as np
import os
import shutil

HOST = '0.0.0.0'
PORT = 5555
SAVE_DIR = "received_frames"
os.makedirs(SAVE_DIR, exist_ok=True)

# 辅助函数：清空目录: 1.一次性删除所有内容, 2.逐个中的所有文件
def clear_directory():
    # for filename in os.listdir(SAVE_DIR):
    #     file_path = os.path.join(SAVE_DIR, filename)
    #     if os.path.isfile(file_path):
    #         os.remove(file_path)
    #         print(f"[INFO] Deleted existing file: {file_path}")
    if os.path.exists(SAVE_DIR):
        shutil.rmtree(SAVE_DIR)
    os.makedirs(SAVE_DIR)
    print(f"[INFO] Directory '{SAVE_DIR}' has been cleared and recreated.")

# 创建 TCP 服务器
def start_server():
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen(1)
        print(f"[INFO] Server listening on {HOST}:{PORT}...")

        while True:  # 🌟 外层循环，持续接收新连接
            print("[INFO] Waiting for a new connection...")
            conn, addr = s.accept()
            frame_count = 0
            with conn:
                print(f"[INFO] Connected by {addr}")

                while True:
                    # Step 1: 读取 4 字节长度头（大端）
                    length_bytes = recv_all(conn, 4)
                    if not length_bytes:
                        print("[WARN] Connection closed by client.")
                        break
                    length = struct.unpack('!I', length_bytes)[0]

                    # Step 2: 读取图像内容
                    img_bytes = recv_all(conn, length)
                    if not img_bytes:
                        print("[WARN] Image data incomplete or connection closed.")
                        break

                    # Step 3: 解码为 OpenCV 图像
                    img_array = np.frombuffer(img_bytes, dtype=np.uint8)
                    img = cv2.imdecode(img_array, cv2.IMREAD_GRAYSCALE)

                    if img is not None:
                        filename = os.path.join(SAVE_DIR, f"frame_{frame_count:06d}.png")
                        cv2.imwrite(filename, img)
                        print(f"[INFO] Frame saved: {filename}")
                        frame_count += 1
                    else:
                        print("[ERROR] Failed to decode image.")

# 辅助函数：确保接收完整指定字节数
def recv_all(sock, size):
    buf = b''
    while len(buf) < size:
        data = sock.recv(size - len(buf))
        if not data:
            return None
        buf += data
    return buf

if __name__ == "__main__":
    # 每次启动服务器时，先清空目录
    clear_directory()
    start_server()
