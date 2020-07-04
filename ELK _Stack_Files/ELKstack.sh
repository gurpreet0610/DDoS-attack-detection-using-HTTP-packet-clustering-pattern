# Creating Network
docker network create elk

# Run elasticsearch
docker run -d \
        --name elasticsearch \
        --net elk \
        -p 9200:9200  \
        -e "discovery.type=single-node" elasticsearch:tag

# Run logstash

docker run -it --rm \
        --name=logstash \
        -v ~/wordpress_data/logstash_config:/conf \
        --net elk \
        -p 5000:5000 \
         -e LS_JAVA_OPTS="-Xms512m -Xmx512m" \
         -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1"\
         logstash:7.7.1  \
         -f /conf/logstash.conf

# Run Kibana

docker run -d \
        --name kibana \
        --net elk \
        -p 5601:5601 kibana