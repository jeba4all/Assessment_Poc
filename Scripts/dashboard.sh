kubectl -n kube-system create sa dashboard
kubectl create clusterrolebinding dashboard --clusterrole cluster-admin --serviceaccount=kube-system:dashboard
kubectl -n kube-system get sa dashboard -o yaml
kubectl -n kube-system describe secrets dashboard-token-
kubectl proxy &
