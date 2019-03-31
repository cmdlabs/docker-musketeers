FROM docker
LABEL maintainer "@flemay"
RUN apk --no-cache update && apk --no-cache upgrade \
    && apk --no-cache add --upgrade make zip git curl py-pip openssl bash \
      gcc python2-dev openssl-dev libffi-dev musl-dev
# for some reasons "gcc python2-dev openssl-dev libffi-dev musl-dev" were required
# to install compose, which previously were not
RUN pip install --upgrade pip docker-compose
CMD [ "make" ]