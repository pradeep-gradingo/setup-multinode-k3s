# setup a control plane
multipass launch --cpus 4 --disk 10G --mem 8G --name control-plane
# setup worker nodes
multipass launch --cpus 4 --disk 15G --mem 12G --name worker1
multipass launch --cpus 4 --disk 15G --mem 12G --name worker2
multipass launch --cpus 4 --disk 15G --mem 12G --name worker3
multipass exec control-plane -- bash -c "curl -sfL https://get.k3s.io | sh -"
TOKEN=$(multipass exec control-plane -- bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")
multipass info control-plane
HOST=control-plane.mshome.net
multipass exec worker1 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec worker2 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec worker3 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$HOST:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec control-plane -- bash -c "sudo cat /etc/rancher/k3s/k3s.yaml"