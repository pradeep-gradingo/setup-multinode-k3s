# Kubernetes multi node cluster using Multipass

Download [multipass](https://multipass.run/) for windows and user Hyper-V.

Watch Detailed [video instructions](https://www.youtube.com/watch?v=t0InEcW3Yy0)

# Setup Instructions
It is advised to use Git bash to perform these actions.
## Fast: Start

### Setup Cluster

To setup the cluster just run the below command from gitbash.
```bash
./build-cluster.sh
```
At the end of the process it will give you the ```kubeconfig``` file - just paste the yaml into ```k3s.yaml``` file and replace line number 5 have value ```server: https://control-plane.mshome.net:6443``` in the ```k3s.yaml``` file.

### Destroy Cluster

To setup the cluster just run the below command from gitbash.
```bash
./destroy-cluster.sh
```

---

💻 Commands used:
===================


```bash
multipass launch --cpus 2 --disk 5G --mem 8G --name control-plane
# after the control-plane is created go to C:\Windows\System32\drivers\etc\hosts.ics file and see the DNS name for the control plane. We will use this to set the HOST variable below.
multipass launch --cpus 4 --disk 10G --mem 8G --name worker1
multipass launch --cpus 4 --disk 10G --mem 8G --name worker2
multipass launch --cpus 4 --disk 10G --mem 8G --name worker3
multipass launch --cpus 4 --disk 10G --mem 8G --name worker4
multipass launch --cpus 4 --disk 10G --mem 8G --name worker5
multipass exec control-plane -- bash -c "curl -sfL https://get.k3s.io | sh -"
TOKEN=$(multipass exec control-plane -- bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")
multipass info control-plane
# we are using the host name followed by the root DNS name for the local home network that windows created (when using hypervisor with private networks). When not using Windows - see next line.
# replace with IP address shown in output of 'multipass info control-plane' command
HOST=control-plane.mshome.net 
multipass exec worker1 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec worker2 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec worker3 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec worker4 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec worker5 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec control-plane -- bash -c "sudo cat /etc/rancher/k3s/k3s.yaml"  # and store it  in  k3s.yaml
notepad k3s.yaml
export KUBECONFIG=k3s.yaml
```

The [k3s.yaml](k3s.yaml) file in this folder is created and you can add the path of this file to environment variables to be able to use kubectl to manage the cluster.
After you get the k3s.yaml file - you can go to C:\Windows\System32\drivers\etc\hosts.ics file and see the DNS name for the control plane. Replace IP address for the control plane in k3s.yaml file.