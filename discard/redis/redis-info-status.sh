#!/bin/bash
REDISPATH=/usr/local/redis-cli
ZAPATH=/etc/zabbix/zabbix_agentd.conf
ZAPATHA=/etc/zabbix/scripts

[ -d ${ZAPATHA} ]|| mkdir -p ${ZAPATHA}

if [ `type redis-cli|wc -l` = 0 ];then
	git clone http://github.com/antirez/redis.git "${REDISPATH}"
	cd ${REDISPATH} && git checkout 3.0 && make redis-cli  && cp src/redis-cli /usr/local/bin && \rm -rf ${REDISPATH} && echo `redis-cli --version`
else
    	echo "redis-cli already exists!"
	echo `redis-cli --version`
	echo "start configure redis and zabbix"
fi

curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/zabbix3.0.2-complete-works/master/redis/redis_hits.sh -o ${ZAPATHA}/redis_hits.sh
curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/zabbix3.0.2-complete-works/master/redis/redis_info.sh -o ${ZAPATHA}/redis_info.sh
chmod +x ${ZAPATHA}/redis*

if [ `grep redis ${ZAPATH}|wc -l` = 0 ];then
	echo "UserParameter=redis_info[*],${ZAPATHA}/redis_info.sh \$1 \$2" >> ${ZAPATH}
	echo "UserParameter=redis_hits,${ZAPATHA}/redis_hits.sh" >> ${ZAPATH}
fi

RECLI=`which redis-cli`
(crontab -l; echo -e "*/1 * * * * ${RECLI} -h 127.0.0.1 -p 6379 info > /tmp/redis-info.txt 2>/dev/null" ) | crontab -

systemctl restart zabbix-agent
echo "tail -10 /var/log/zabbix/zabbix_agentd.log"
tail -10 /var/log/zabbix/zabbix_agentd.log
