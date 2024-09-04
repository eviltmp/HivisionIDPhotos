FROM debian:11

# apt换源，安装pip
RUN echo "==> 换成清华源，并更新..."  && \
    sed -i 's#http://\w*.debian.org/#http://mirrors.ustc.edu.cn/#' /etc/apt/sources.list && \
    apt-get clean  && \
    apt-get update

# 安装python3.10
RUN apt-get install -y python3 python3-pip curl && \
    pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip3 install -U pip

# 安装ffmpeg等库
RUN apt-get install libpython3.9-dev ffmpeg libgl1-mesa-glx libglib2.0-0 cmake -y && \
    pip3 install --no-cache-dir cmake

WORKDIR /app

COPY . .

RUN pip3 install -r requirements.txt

RUN echo "==> Clean up..."  && \
    rm -rf ~/.cache/pip

# 指定工作目录

EXPOSE 7860

CMD [ "python3", "app.py", "--host", "0.0.0.0", "--port", "7860"]
