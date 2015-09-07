#
#  Copyright 2015 yafra.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

#
# yafra.org PHP / Apache2 docker image
#

# source is yafra ubuntu
FROM yafraorg/docker-yafrabase

MAINTAINER Martin Weber <info@yafra.org>

# Install PHP / Apache2 packages
RUN apt-get update && \
  curl -sL https://deb.nodesource.com/setup | sudo bash - && \
  apt-get install -yq apache2 apache2-mpm-prefork apache2-utils libapache2-mod-php5 libapr1 libaprutil1  && \
  apt-get install -yq libpq5 mysql-client-5.5 php5-common curl php5-curl php5-mysqlnd nodejs && \
  rm -rf /var/lib/apt/lists/*

# Install NodeJS packages
RUN npm -g install bower gulp-cli

# Install PHP composer
RUN curl -s http://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin
RUN cd /work/repos && git clone https://github.com/yafraorg/yafra-php.git
RUN rm /var/www/html/*

# change default port of apache
RUN sed -i "/Listen/s/80/8083/" /etc/apache2/ports.conf

COPY run-docker.sh /work/run-docker.sh
RUN cd /work && \
  chmod 755 run-docker.sh

WORKDIR /work

EXPOSE 8083

CMD ["/work/run-docker.sh"]
