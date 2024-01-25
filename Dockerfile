FROM python:3.11.4-slim
ENV PATH=$PATH:/opt
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
COPY requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt
COPY samplesheet_generator.py /opt/
COPY test /opt/test
COPY indexes /opt/indexes
