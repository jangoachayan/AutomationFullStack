ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for Python 3
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Copy data for add-on
COPY . /app
WORKDIR /app

# S6-Overlay Service Definitions
COPY run /etc/services.d/backend/run
COPY finish /etc/services.d/backend/finish
RUN chmod a+x /etc/services.d/backend/run
RUN chmod a+x /etc/services.d/backend/finish

# Python needs this to flush stdout immediately for S6 logging
ENV PYTHONUNBUFFERED=1

CMD [ "/init" ]
