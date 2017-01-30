FROM mesosphere/mesos:0.28.1-2.0.20.ubuntu1404

# Install Oracle JDK instead of OpenJDK
RUN apt-get remove -y --auto-remove openjdk* && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections && \
    sudo apt-get install -y oracle-java8-installer oracle-java8-set-default && \
    rm -r /var/cache/oracle-jdk*

# Update the base ubuntu image with dependencies needed for Spark
RUN apt-get install -y python libnss3 curl unzip

RUN mkdir /usr/lib/spark-1.6.2-bin-hadoop2.6 && \
    curl http://archive.apache.org/dist/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz \
    | tar --strip-components=1 -xzC /usr/lib/spark-1.6.2-bin-hadoop2.6 && \
    rm /usr/lib/spark-1.6.2-bin-hadoop2.6/lib/spark-examples-*.jar

ENV SPARK_HOME /usr/lib/spark-1.6.2-bin-hadoop2.6
ENV PATH $PATH:/usr/lib/spark-1.6.2-bin-hadoop2.6/bin
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
