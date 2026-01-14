FROM python:3.13.11-slim

RUN pip install pandas pyarrow fastparquet 

WORKDIR /code
COPY pipeline.py .

ENTRYPOINT ["python", "pipeline.py"]