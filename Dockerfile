# work from latest LTS ubuntu release
FROM ubuntu:20.04

# set environment variables
ENV hisat2_version 2.2.1

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    build-essential \
    libnss-sss \
    vim \
    wget \
    libpthread-stubs0-dev \
    default-jdk \
    python3 \
    python \
    python-pip

# install hisat2
WORKDIR /usr/local/bin
RUN wget https://github.com/DaehwanKimLab/hisat2/archive/v${hisat2_version}.tar.gz
RUN tar -xvzf v${hisat2_version}.tar.gz
WORKDIR /usr/local/bin/hisat2-${hisat2_version}
RUN make
RUN ln -s /usr/local/bin/hisat2-${hisat2_version}/hisat2 /usr/local/bin/hisat2

# set path to find the genotype scripts and modules
ENV PATH /usr/local/bin/hisat2-${hisat2_version}/genotype_scripts:${PATH}
ENV PATH /usr/local/bin/hisat2-${hisat2_version}:${PATH}
ENV PYTHONPATH /usr/local/bin/hisat2-${hisat2_version}/hisatgenotype_modules:${PYTHONPATH}

# download the graph index, (this may not be the most up to date)
WORKDIR /opt
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat-genotype/data/genotype_genome_20180128.tar.gz
RUN tar -xzvf genotype_genome_20180128.tar.gz
RUN rm -f genotype_genome_20180128.tar.gz

# set default command
WORKDIR /usr/local/bin
