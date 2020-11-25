FROM sixsq/opencv-python:master-arm

WORKDIR /tmp
COPY requirements.txt .

RUN apt-get -q update && apt-get -y install libraspberrypi-bin && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt

COPY scripts/ .


CMD ["python3", "./main.py", "-t 60", "--screen_output"]
#CMD ["python3", "./test.py"]