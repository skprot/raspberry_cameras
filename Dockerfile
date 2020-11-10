FROM sixsq/opencv-python:master-arm

COPY requirements.txt /tmp
WORKDIR /tmp

RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt

CMD ['python3', './main.py', '--time 60']