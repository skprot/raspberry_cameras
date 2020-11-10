FROM sixsq/opencv-python:master-arm

COPY requirements.txt /tmp
WORKDIR /tmp

RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt

COPY scripts/ .

CMD ["python3", "./main.py", "-t 60"]