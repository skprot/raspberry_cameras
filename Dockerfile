FROM sixsq/opencv-python:master-arm

WORKDIR /tmp
COPY requirements.txt .

RUN apt-get -q update && apt-get -y install libraspberrypi-bin && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt
RUN usermod -a -G video root

COPY scripts/ .

CMD ["python3", "./test.py", "-t 60", "--screen_output"]