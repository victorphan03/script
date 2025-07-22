#!/bin/bash

# --- Bắt đầu cấu hình ---
# Người dùng hiện tại sẽ được thêm vào nhóm 'docker'
CURRENT_USER=$(whoami)
# --- Kết thúc cấu hình ---

echo "--- Bắt đầu quá trình cài đặt Docker và Docker Compose ---"

# 1. Cập nhật hệ thống và cài đặt các gói phụ thuộc
echo "1. Cập nhật hệ thống và cài đặt các gói phụ thuộc..."
sudo apt update -y
sudo apt install ca-certificates curl gnupg lsb-release -y || { echo "Lỗi: Không thể cài đặt các gói phụ thuộc. Hãy kiểm tra kết nối mạng hoặc quyền."; exit 1; }

# 2. Thêm khóa GPG chính thức của Docker
echo "2. Thêm khóa GPG chính thức của Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || { echo "Lỗi: Không thể thêm khóa GPG của Docker."; exit 1; }
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 3. Thêm kho lưu trữ Docker vào danh sách nguồn APT
echo "3. Thêm kho lưu trữ Docker vào danh sách nguồn APT..."
echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  \"$(. /etc/os-release && echo "$VERSION_CODENAME")\" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || { echo "Lỗi: Không thể thêm kho lưu trữ Docker."; exit 1; }

# 4. Cập nhật lại danh sách gói sau khi thêm kho lưu trữ
echo "4. Cập nhật lại danh sách gói..."
sudo apt update -y || { echo "Lỗi: Không thể cập nhật danh sách gói sau khi thêm kho lưu trữ Docker."; exit 1; }

# 5. Cài đặt Docker Engine, CLI, containerd và Docker Compose Plugin
echo "5. Cài đặt Docker Engine, CLI, containerd và Docker Compose Plugin..."
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y || { echo "Lỗi: Không thể cài đặt Docker hoặc các plugin. Có thể phiên bản HĐH không tương thích."; exit 1; }

# 6. Thêm người dùng hiện tại vào nhóm 'docker'
echo "6. Thêm người dùng '$CURRENT_USER' vào nhóm 'docker'..."
sudo usermod -aG docker "$CURRENT_USER" || { echo "Cảnh báo: Không thể thêm người dùng vào nhóm 'docker'. Bạn có thể cần chạy lệnh Docker với 'sudo'."; }

# 7. Kiểm tra trạng thái cài đặt
echo "7. Kiểm tra trạng thái Docker..."
sudo systemctl status docker --no-pager

echo "8. Kiểm tra phiên bản Docker và Docker Compose..."
docker --version
docker compose version

echo "--- Quá trình cài đặt Docker và Docker Compose đã hoàn tất ---"
echo "LƯU Ý QUAN TRỌNG: Bạn cần ĐĂNG XUẤT và ĐĂNG NHẬP lại (hoặc khởi động lại terminal/hệ thống) để các thay đổi về quyền có hiệu lực."
echo "Sau khi đăng nhập lại, bạn có thể kiểm tra bằng cách chạy: docker run hello-world"