����Ȼʹ���˼���򵥵ķ�ʽ�����iptables�仯����������Ҫע�⣬����仯�ı�����ʱ��ǳ���

```
UserParameter=iptables_lins,/usr/bin/sudo iptables -S |md5sum|awk '{print $1}'
UserParameter=iptables_file,/usr/bin/sudo /usr/bin/cksum /etc/sysconfig/iptables|awk '{print $1}'
```

���⣬��ҪsudoȨ��
```
zabbix ALL=(root)NOPASSWD:/usr/sbin/iptables,/usr/bin/cksum /etc/sysconfig/iptables
```