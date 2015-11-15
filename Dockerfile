FROM ubuntu
MAINTAINER Mario Kostelac

ADD docker-build /build
RUN bash /build/setup.sh
ADD . /ra
RUN make -C /ra clean
RUN make -C /ra
