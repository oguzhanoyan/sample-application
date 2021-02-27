<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#restriction">Restriction</a></li>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#yaml-files-and-dockerfile-explanation">Yaml Files and Dockerfile Explanation</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
  </ol>
</details>



## About The Project

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This sample application include Python script and that connect to Mysql through in Kubernetes same namespace but different deployments. Works only local kubernetes(minicube). 



### Built With

* [Minikube == v1.17.1 on Darwin 11.1](https://minikube.sigs.k8s.io/docs/start/)
* [Python == 3.7](https://www.python.org/downloads/release/python-370/)
* [Flask](https://pypi.org/project/Flask/)
* [Gunicorn](https://pypi.org/project/gunicorn/)
* [mysqlclient](https://pypi.org/project/mysqlclient/)



## Getting Started

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;All of yamls and setups develop in minikube to run local kubernetes cluster.



### Restriction

#### PersistentVolume Restriction

  * Types of Persistent volume is `local` due to Local kubernetes cluster(Minicube). If you want to attach it into different persistent disk you have to change PersistentVolume [Type](). You can reach all of the plugins from [here](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes).
  * PV accessModes: ReadWriteOnce and means is that: The volume can be mounted as read-write by a single node. If you want to implement it multi-node cluster, you have to change that properties. Detailed explanation [here](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)
  * PV has also persistentVolumeReclaimPolicy:Retain and means is that: When the PersistentVolumeClaim is deleted, the PersistentVolume still exists and the volume is considered "released".
  * Host path of the persistent volume can accessible from /mnt/data from minikube node.
  * PV size is 20Gi. 

#### Application Restriction 

  * I have dockerize python application as you can reach from Dockerfile. And uploaded it into DockerHub. If you want to use different image you have to change the container image from(Deployments/app.yaml). 
  * `MYSQL_PORT_3306_TCP_ADDR` and `MYSQL_PORT_3306_TCP_PORT` environment variables comes from mysql deployment.
  * If you want to change default username, password and database, you have to check out env variables. 

#### MySQL Restriction
  * PV mount path same as mysql files path. (/var/lib/mysql)

### Prerequisites

Must be install minikube on your local computer.


### Yaml Files and Dockerfile Explanation
Dockerfile 

1) In order to use application inside of the minikube i had to turned python application into Dockerfile and uploaded into Dockerhub for fetching that image inside of the yaml file as container. As you can see i have installed required(Flask gunicorn mysqlclient) python library in a line due to simplicity. I could also install required python library from requirements.txt. Also i want to mention that: server will deploy on gunicorn port 3000. I could not change default port. 


In deployments folder:

1) I have to apply PersistentVolume into cluster with:
      * kubectl apply -f pv.yaml
      * This execution will be create persistent disk inside of the cluster to attach into Mysql cluster.

2) Now i can install mysql cluster into pod through kubectl command:
      * kubectl apply -f mysql-server.yaml 
      * This execution will be create one pod that include Mysql client on 3306 port and have pv volume. Also have service yaml inside the yaml to get ClusterIp for connection between main application. 

3) In order to install Application and setup MySQL connection:
      * kubectl apply -f app.yaml
      * This execution will be deploy our python application with gunicorn on 3000 port and connect to MySQL by Environment Variables. Also it services that inside of the app.yaml. 

4) Due to local cluster, i have to use `minikube service <service-name>` for expose python application. 
      * minikube service sample-app-service 
      * After exposing server, you'll reaching the pyhton application page on your default browser. 

### Installation

In the root folder there is a file named as `installation.yaml` and this consist of the Deployments folder Yaml's(pv.yaml, mysql-server.yaml, app.yaml). In order to run a single command i have wrote bash script. That script will check whether minicube exist or not(running or stopped, if stopped running again minikube) after that will execute installation.yaml file. And last step will be expose your application and redirect your default browser. , and check whether python application is running or not.

      * Clone repository into your computer
      * Give run permission to build.sh or log in as root
      * run in terminal as: ./build.sh
      * Just wait to complete deployment, it will redirect to your default browser. 

## Usage
Video: 

[![How to click the deploy sample application](http://img.youtube.com/vi/wuVXMKFxzd4/0.jpg)](http://www.youtube.com/watch?v=wuVXMKFxzd4 "How to click the deploy sample application")
