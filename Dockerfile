FROM sixsq/opencv-python:master-arm

COPY requirements.txt /tmp
WORKDIR /tmp

RUN apt-get -q update && apt-get -y install libraspberrypi-bin && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt
RUN usermod -a -G video root

COPY scripts/ .

CMD ["python3", "./main.py", "-t 60"]