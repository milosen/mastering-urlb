FROM nvidia/cuda:11.0.3-base-ubuntu20.04

# install ubuntu dependencies
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && \
    apt-get -y install python3-pip xvfb ffmpeg git build-essential python-opengl
RUN ln -s /usr/bin/python3 /usr/bin/python

# install python dependencies
#RUN mkdir cleanrl_utils && touch cleanrl_utils/__init__.py
#RUN pip install poetry --upgrade
#COPY pyproject.toml pyproject.toml
#COPY poetry.lock poetry.lock
#RUN poetry install

# install mujoco_py
RUN apt-get -y install wget unzip software-properties-common \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev patchelf
#RUN poetry install -E "atari mujoco_py"
#RUN poetry run python -c "import mujoco_py"
#COPY ./requirements /requirements
#RUN pip install -r /requirements/requirements.txt
#RUN pip install -r /requirements/requirements-atari.txt
# RUN pip install -r /requirements/requirements-dm_control.txt
# RUN pip install -r /requirements/requirements-mujoco.txt
#RUN pip install -r /requirements/requirements-optuna.txt

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

RUN mkdir -p /root/.mujoco \
    && wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O mujoco.tar.gz \
    && tar -xf mujoco.tar.gz -C /root/.mujoco \
    && rm mujoco.tar.gz

ENV LD_LIBRARY_PATH /root/.mujoco/mujoco210/bin:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# install python bindings and trigger build of cpython libraries
# "cython<3"
#RUN pip install mujoco mujoco_py "cython<3" shimmy[dm-control]
#RUN python -c "import mujoco_py"
#RUN conda env create -f conda_env.yml
#RUN conda activate urlb

RUN mkdir /workspace
ENV PYTHONPATH ${PYTHONPATH}:/workspace

WORKDIR /workspace
COPY entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# copy local files
# COPY ./cleanrl /cleanrl
