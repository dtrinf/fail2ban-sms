# fail2ban-sms
Fail2ban configuration to send a SMS after blocking a SSH non authorized connection.

-------------------------------------------------------------

El primer paso es crearse una cuenta gratuita en [Twilio](https://www.twilio.com/)

Una vez tengamos la cuenta creada instalaremos fail2ban, en este caso, lo hemos hecho sobre Debian.

```
aptitude install fail2ban
```

Una vez instalado, es necesario crear la acción en fail2ban que envíe un SMS.

```
vi /etc/fail2ban/action.d/sms.conf
```

Ahora configuramos fail2ban para que al bloquear una conexión SSH, ejecute esta acción.
Es necesario modificar la directiva "[ssh]"


```
vi /etc/fail2ban/jail.conf

[ssh]

enabled  = true
port     = ssh
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 6
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           sms
```

Una vez configurado fail2ban, es necesario crear el script que enviará los SMS.

```
vi /root/scripts/sms.conf
chmod 755 /root/scripts/sms.conf
```

Por último, creamos el fichero con las credenciales, el cual solo tendrá permisos de lectura por el usuario root para securizarlo.


```
vi /root/scripts/secret.conf
chmod 755 /root/scripts/secret.conf
```


Ahora probamos el script para verificar que envía los SMS Correctamente

```
/root/scripts/sms.sh start && /root/scripts/sms.sh ban 127.0.0.1
```


Y por último, solo queda reiniciar el servicio de fail2ban para que actualize los cambios

```
systemctl restart fail2ban
```
