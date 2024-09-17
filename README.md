# prometheus-aws
The Terraform code will set up an EC2 instance and install Prometheus and Grafana using a [userdata script](https://github.com/brucelok/prometheus-aws/blob/main/userdata.tpl).

Before running the Terraform code, you might want to change the following:

1.	Add your IP address to the `whitelist_ip` in **variables.tf**, as the security group only allows access from the whitelisted IP.
2.	Update the `key_name` for SSH in **variables.tf**.
3.	Modify the `PROMETHEUS_VERSION` and **CPU architecture** in the userdata script to ensure you download the correct binary for your OS.

Once the installation is done, you can access the Prometheus dashboard on port 9090 and Grafana on port 3000. 

If anything goes wrong, check the status to troubleshoot.
```
systemctl status prometheus grafana-server
systemctl status grafana-server.service
netstat -lntp
```

You can add or remove target config from the file `/etc/prometheus/prometheus.yml`.