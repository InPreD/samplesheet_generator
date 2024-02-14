FROM python:3.11.4-slim
ENV PATH=$PATH:/opt
COPY requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt
COPY samplesheet_generator.py /opt/
COPY indexes /opt/indexes
