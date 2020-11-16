# Kubernetes multi node cluster using Multipass

Download [multipass](https://multipass.run/) for windows and user Hyper-V.

Watch Detailed [video instructions](https://www.youtube.com/watch?v=t0InEcW3Yy0)

💻 Commands used:
===================

It is advised to use Git bash to perform these actions.
```bash
multipass launch -n control-plane
# after the control-plane is created go to C:\Windows\System32\drivers\etc\hosts.ics file and see the DNS name for the control plane. We will use this to set the HOST variable below.
multipass launch -n worker1
multipass launch -n worker2
multipass exec control-plane -- bash -c "curl -sfL https://get.k3s.io | sh -"
TOKEN=$(multipass exec control-plane -- bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")
multipass info control-plane
HOST=control-plane.mshome.net  #replace with IP address shown in output of 'multipass info control-plane' command
multipass exec worker1 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec worker2 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec control-plane -- bash -c "sudo cat /etc/rancher/k3s/k3s.yaml"  # and store it  in  k3s.yaml
notepad k3s.yaml
export KUBECONFIG=k3s.yaml
```

The [k3s.yaml](k3s.yaml) file in this folder is created and you can add the path of this file to environment variables to be able to use kubectl to manage the cluster.
After you get the k3s.yaml file - you can go to C:\Windows\System32\drivers\etc\hosts.ics file and see the DNS name for the control plane. Replace IP address for the control plane in k3s.yaml file.