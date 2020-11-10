FROM sixsq/opencv-python:master-arm

WORKDIR /tmp
COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt

COPY scripts/ .

CMD ["python3", "./main.py", "-t 60"]