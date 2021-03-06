FROM python:3.7-slim-buster

WORKDIR /code/
# RUN apt-get update && apt-get install -y software-properties-common gpg wget && \
#     apt-get install -y --no-install-recommends build-essential gcc && \
#     wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - && \
#     apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
#     apt update && \
#     apt-get install -y --no-install-recommends cmake

RUN apt-get update && apt-get install -y build-essential gcc cmake

# Array file
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libboost-all-dev && \
    apt-get install -y build-essential git cmake libfreeimage-dev && \
    apt-get install -y cmake-curses-gui && \
    apt-get install -y libopenblas-dev libfftw3-dev liblapacke-dev && \
    apt-get install -y libatlas3-base libatlas-base-dev libfftw3-dev liblapacke-dev && \
    git clone --recursive https://github.com/arrayfire/arrayfire.git --branch v3.6.4 && cd arrayfire && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DAF_BUILD_CUDA=OFF -DAF_BUILD_OPENCL=OFF && \
    make -j8 && make install

# Gloo
COPY gloo.zip .
RUN apt-get install -y openmpi-bin openmpi-common libopenmpi-dev unzip && \
    unzip -qq gloo.zip && \
    cd gloo && mkdir -p build && cd build && \
    cmake .. -DUSE_MPI=ON && \
    make -j8 && make install

# MKL-DNN
RUN git clone https://github.com/intel/mkl-dnn.git -b mnt-v0 && \
    cd mkl-dnn && mkdir -p build && cd build && \
    cmake ..  && \
    make -j8 && make install

# Flashlight
COPY flashlight.zip .
RUN export MKLROOT=/opt/intel/mkl && \
    unzip -qq flashlight.zip && \
    cd flashlight && mkdir -p build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DFLASHLIGHT_BACKEND=CPU && \
    make -j8 && make install

# KenLM
RUN apt-get install -y libsndfile-dev libopenblas-dev libfftw3-dev libgflags-dev libgoogle-glog-dev && \
    apt-get install -y liblzma-dev libbz2-dev libzstd-dev && \
    apt-get install -y libeigen3-dev && \
    git clone https://github.com/kpu/kenlm.git && \
    cd kenlm && mkdir -p build && cd build && \
    cmake .. -DKENLM_MAX_ORDER=20 && \
    make -j8 && make install

# wav2letter with CPU backend
RUN apt-get install -y libhdf5-dev && \
    export MKLROOT=/opt/intel/mkl && export KENLM_ROOT_DIR=/code/kenlm && \
    git clone https://github.com/mailong25/wav2letter.git && \
    cd wav2letter && mkdir -p build && \
    cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DW2L_LIBRARIES_USE_CUDA=OFF -DKENLM_MAX_ORDER=20 && \
    make -j8

# Minor
RUN apt-get install -y ffmpeg

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -U -r /tmp/requirements.txt

RUN mkdir /code/vietnamese-speech-recognition
COPY . /code/vietnamese-speech-recognition
WORKDIR /code/vietnamese-speech-recognition
ENTRYPOINT [ "/bin/bash" ]
