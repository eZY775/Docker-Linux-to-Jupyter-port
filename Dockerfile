FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# System utilities
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    vim \
    git \
    iputils-ping \
    sudo \
    ca-certificates \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Python packages for data engineering
RUN pip3 install --no-cache-dir \
    jupyterlab \
    pandas \
    numpy \
    sqlalchemy \
    psycopg2-binary \
    pymysql

# Create non-root user
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/${USERNAME}/workspace

USER ${USERNAME}

# Expose Jupyter port
EXPOSE 8888

# Start Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token="]
