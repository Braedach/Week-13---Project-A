### Leon Scott -- Week 13 - ELK STACK Project A
#### _June 04, 2022 -- UniWA Cybersecurity - Boot Camp_  

ELK Stack Deployment
==============================
The files in this repository were used to configure the network depicted below

[Network Diagram](/Diagrams/Network-Diagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the YAML or config file may be used to install only certain pieces of it, such as Filebeat


This document contains the following details:
- Description of the Topologu
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build

-------------------------------------------------------------------------------------------------------------------------------------------

## Topology  

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.
Load balancing ensures that the application will ensure a high availablilty, in addition to vetting traffic to the network.

- What aspect of security do load balancers protect?
  - **_Load balancers add resiliency by rerouting live traffic from one server to another if a server becomes unavailable.

- What is the advantage of a jump box?
  - **_A Jump Box Provisioner is important as it prevents Azure VMs from being exposed via a public IP Address. This allows us to do monitoring and logging on a single box. We can also restrict the IP addresses able to access the Jump Box_**

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the **_network_** and system **_system logs_**.

- What does Filebeat watch for?
  - **_Filebeat, as the name implies, ships log files. In an ELK-based logging pipeline, Filebeat plays the role of the logging agent—installed on the machine generating the log files, tailing them, and forwarding the data to either Logstash for more advanced processing or directly into Elasticsearch for indexing_**
 
- What does Metricbeat record?
  - **_Metricbeat uses modules to collect metrics. Each module defines the basic logic for collecting data from a specific service, such as Redis or MySQL. A module consists of metricsets that fetch and structure the data._**

The configuration details of each machine may be found below.

| Name              | Function        | IP Address               | Operating System   |
|-------------------|-----------------|--------------------------|--------------------|
| Jump Box          | Gateway         | 10.0.0.4 / 20.213.237.211| Linux              |
| Web-1             | UbuntuServer    | 10.0.0.5 / 	           | Linux              |
| Web-2             | UbuntuServer    | 10.1.0.6 /               | Linux              |
| ELKserver         | UbuntuServer    | 10.2.0.4 / 52.255.61.111 | Linux              |


-------------------------------------------------------------------------------------------------------------------------------------------

## Access Policies  

The machines on the internal network are not exposed to the public Internet.

Machines within the network can only be accessed by my workstations public IP address.

A summary of the access policies in place can be found in the table below.

| Name              | Publicly Accessible | Allowed IP Addresses |
|-------------------|---------------------|----------------------|
| Jump Box          | Yes - Restricted IP | IAW NSG              |
| Web-1             | No                  |                      |
| Web-2             | No                  |                      |
| ELKserver         | Yes - Restricted IP | IAW NSG              |



-------------------------------------------------------------------------------------------------------------------------------------------

## Elk Configuration  
Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...

- What is the main advantage of automating configuration with Ansible?
  - There are multiple advantages, Ansible lets you quickly and easily deploy multiple applications throught the YAML playbook
  - No requirement to repeat coding across systems
  - Scaleable - from 2-3 VMs to many more with limited additional work
  - Ansible reports the configuration state of your machines to allow for easy fault finding

The playbook implements the following tasks:

- In 3-5 bullets, explain the steps of the ELK installation play. E.g., install Docker; download image; etc.
  - Specify a different group of machines:
      ```yaml
        - name: Config elk VM with Docker
          hosts: elk
          become: true
          tasks:
      ```
  - Install Docker.io
      ```yaml
        - name: Install docker.io
          apt:
            update_cache: yes
            force_apt_get: yes
            name: docker.io
            state: present
      ``` 
  - Install Python-pip
      ```yaml
        - name: Install python3-pip
          apt:
            force_apt_get: yes
            name: python3-pip
            state: present

          # Use pip module (It will default to pip3)
        - name: Install Docker module
          pip:
            name: docker
            state: present
            `docker`, which is the Docker Python pip module.
      ``` 
  - Increase Virtual Memory
      ```yaml
       - name: Use more memory
         sysctl:
           name: vm.max_map_count
           value: '262144'
           state: present
           reload: yes
      ```
  - Download and Launch ELK Docker Container (image sebp/elk)
      ```yaml
       - name: Download and launch a docker elk container
         docker_container:
           name: elk
           image: sebp/elk:761
           state: started
           restart_policy: always
      ```
  - Published ports 5044, 5601 and 9200 were made available
      ```yaml
           published_ports:
             -  5601:5601
             -  9200:9200
             -  5044:5044   
      ```

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.  

ELKserver
---------
[ELK Server](/Images/docker-elk-server.png)

Jump-Box-Provisioner
--------------------
[Jump Box Ansible Container](/Images/docker-jump-box-provisioner.png)

Web-1
-----
[Web-1 DVWA](/Images/docker-web-1.png)

Web-2
-----
[Web-1 DVWA](/Images/docker-web-1.png)



-------------------------------------------------------------------------------------------------------------------------------------------

## Target Machines & Beats  
This ELK server is configured to monitor the following machines:

- List the IP addresses of the machines you are monitoring
  - Web-1: 10.0.0.5
  - Web-2: 10.0.0.6

 
We have installed the following Beats on these machines:

Filebeat
[Filebeat Successful](/Images/filebeat-installation-successful.png)

Metricbeat
[Metricbeat Successful](/Images/metricbeat-installation-successful.png)

These Beats allow us to collect the following information from each machine:

  - Filebeat will be used to collect log files from the above meantioned machines.
    - This includes all logs on the system which are specified such as access logs, event logs, docker logs and so forth.

  - Metericbeat will be used to monitor VM stats, per CPU core stats, per filesystem stats, memory stats and network stats.

------------------------------------------------------------------------------------------------------------------------------------------- 

## Using the Playbook to configure ELK  
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned:

- Verify the Public IP address to see if it has changed. [What Is My IP?](https://www.ipx.ac/)
- If changed then update the Security Rules that uses the My Public IPv4

SSH into the control node and follow the steps below:

- Copy the install-elk YAML file to the /etc/ansible directory
- [ELK Installation and VM Configuration ](https://github.com/Braedach/Week-13---Project-A/blob/main/Ansible/install-elk.yml)
- Update the host file in the /etc/ansible directory to include the new elk server
- Run the playbook
    - type the following command: 'ansible-playbook /etc/ansible/install-elk.yml'
    - watch the output - the following should be seen - play recap - ok=7 although on initial run you will see changed=7
    - connect to your elk server via http://[your ip address]:5601/app/kibana
    - we are now ready to install the filebeat and metricbeat agents


[Ansible Hosts File Elk](/Images/filebeat-installation-successful.png)
[Ansible Playbook Run](/Images/ansible-run-playbook.png)
[Ansible ELK Configuration successful](/Images/ansible-run-playbook-successful.png)

## Installing and Configuring Filebeat

 - Whilst still connected to the anisble container
 - Download the following file 'filebeat-config.yml and install it to /etc/ansible/files directory
 - [Filebeat Configuration File](https://github.com/Braedach/Week-13---Project-A/blob/main/Ansible/Agents/filebeat-configuration.yml)
 - modify line 1105 to reflect your ELK server - hosts:
 - modify line 1804 to reflect your ELK server - setup.kibana
 - Download the following file 'filebeat-playbook.yml and install it to the /etc/ansible/roles directory
 - [Filebeat Playbook File](https://github.com/Braedach/Week-13---Project-A/blob/main/Ansible/Agents/filebeat-playbook.yml)
 - The Filebeat should be checked to confirm that it applies to all webservers
 - Run the playbook
     - type the following command: 'ansible-playbook /etc/ansible/filebeat-playbook.yml'
     - once installation is successful on both Web hosts you should then click on the following link
     - http://[your ELK IP Address]:5601/app/kibana#/home/tutorial/systemLogs
     - go to 'Module status' and check data - you should get successfully receiving data


## Installing and Configuring Metricbeat

 - Whilst still connected to the anisble container
 - Download the following file 'metricbeat-config.yml and install it to /etc/ansible/roles directory
 - [Metricbeat Configuration File](https://github.com/Braedach/Week-13---Project-A/blob/main/Ansible/Agents/metricbeat-configuration.yml)
 - modify line 61 to reflect your ELK server - setup.kibana
 - modify line 95 to reflect your ELK server - hosts
 - Download the following file 'metricbeat-playbook.yml and install it to the /etc/ansible/roles directory
 - [Metricbeat Playbook File](https://github.com/Braedach/Week-13---Project-A/blob/main/Ansible/Agents/metricbeat-playbook.yml)
 - The Metricbeat should be checked to confirm that it applies to all webservers
 - Run the playbook
     - type the following command: 'ansible-playbook /etc/ansible/metricbeat-playbook.yml'
     - once installation is successful on both Web hosts you should then click on the following link
     - http://[your ELK IP Address]:5601/app/kibana#/home/tutorial/systemMetrics
     - go to 'Module status' and check data - you should get successfully receiving data



-------------------------------------------------------------------------------------------------------------------------------------------


## System Commands

 - The following system commands will be required



|            COMMAND                               | PURPOSE                                               |
|--------------------------------------------------|-------------------------------------------------------|                         
|`ssh-keygen`                                      |  create a ssh key for setup VM's                      |
|`sudo cat .ssh/id_rsa.pub`                        |  to view the ssh public key                           |
|`ssh azadmin@Jump-Box-Provisioner IP address`     |  to log into the Jump-Box-Provisioner                 |
| `sudo docker container list -a`                  | list all docker containers                            |
| `sudo docker start dremy_elbakyan`               | start docker container dremy_elbakyan                 |
|`sudo docker ps -a`                               |  list all active/inactive containers                  |
|`sudo docker attach dremy_elbakyan`               |  effectively sshing into the dremy_elbakyan container |
|`cd /etc/ansible`                                 | Change directory to the Ansible directory             |
|`ls -laA`                                         | List all file in directory (including hidden)         |
|`nano /etc/ansible/hosts`                         |  to edit the hosts file                               |
|`nano /etc/ansible/ansible.cfg`                   |  to edit the ansible.cfg file                         |
|`nano /etc/ansible/pentest.yml`                   |  to edit the My-Playbook                              |
|`ansible-playbook [location][filename]`           |  to run the playbook                                  |
|`sudo lsof /var/lib/dpkg/lock-frontend`           | unlocking a locked file                               |
|`ssh ansible@Web-1 IP address`                    |  to log into the Web-1 VM                             |
|`ssh ansible@Web-2 IP address`                    |  to log into the Web-2 VM                             |
|`ssh ansible@DVWA-VM3 IP address`                 |  to log into the DVWA-VM3 VM                          |
|`ssh ansible@ELKserver IP address`                |  to log into the ELKserver VM                         |
|`exit`                                            | to exit out of docker containers/Jump-Box-Provisioners|
|`nano /etc/ansible/ansible.cfg`                   |  to edit the ansible.cfg file                         |
|`nano /etc/ansible/hosts`                         |  to edit the hosts file                               |
|`nano /etc/ansible/pentest.yml`                   |  to edit the My-Playbook                              |
|`ansible-playbook [location][filename]`           |  to run the playbook                                  |
|`sudo apt-get update` 				                     |  this will update all packages                        |
|`sudo apt install docker.io`				               |  install docker application		                       |
|`sudo service docker start`				               |  start the docker application                         |
|`sudo systemctl status docker`				             |  status of the docker application                     |
|`sudo systemctl start docker`                     |  start the docker service                             |
|`sudo docker pull cyberxsecurity/ansible`	       |  pull the docker container file                       |
|`sudo docker run -ti cyberxsecurity/ansible bash` |  run and create a docker container image              |
|`ansible -m ping all`                             |  check the connection of ansible containers           |
|`curl -L -O [location of the file on the web]`    |  to download a file from the web                      |
|`dpkg -i [filename]`                              |  to install the file i.e. (filebeat & metricbeat)     |
|`http://20.84.136.248:5601//app/kibana`           | Open web browser and navigate to Kibana Logs          |
|`nano filebeat-config.yml`                        | create and edit filebeat config file                  |
|`nano filebeat-playbook.yml`                      | write YAML file to install filebeat on webservers     |
|`nano metricbeat-config.yml`                      | create metricbeat config file and edit it             |
|`nano metricbeat-playbook.yml`                    | write YAML file to install metricbeat on webservers   |  
------------------------------------------------------------------------------------------------------------

@Leon Scott - University of Western Austrlia - Cybersecurity Bootcamp

