FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
	python \
        python3-dev \
        rsync \
        software-properties-common \
        unzip \
        libgtk2.0-0 \
        git \
	tcl-dev \
	tk-dev \	
	wget \
	python3-pip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh tmp/Miniconda3-4.2.12-Linux-x86_64.sh
RUN bash tmp/Miniconda3-4.2.12-Linux-x86_64.sh -b
ENV PATH $PATH:/root/miniconda3/bin/

COPY environment-gpu.yml  ./environment.yml
RUN conda env create -f=environment.yml --name carnd-ss --debug -v -v

# cleanup tarballs and downloaded package files
RUN conda clean -tp -y

# Term 1 workdir
RUN mkdir /src
WORKDIR "/src"

# Make sure CUDNN is detected
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64/:$LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda/lib64/libcudnn.so.6 /usr/local/cuda/lib64/libcudnn.so

# TensorBoard
EXPOSE 6006
# Flask Server
EXPOSE 4567

