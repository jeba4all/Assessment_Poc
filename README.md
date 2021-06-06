# Assessment_Poc
Kubernetes Provision using Ansible

This is to install Kubenetes cluster using Ansible and install dashboard packages, helm packages, Ingress Controller, Loadbalancer, Sample demo service and Ingress file for DNS configuration.

1.Clone the Git Url
2.Move to Ansible folder and change the inventary entry based on your workspace path.
3.Add the master and host entry to the hosts files based on the clsuter nodes used and verify for internal connectivities.
4.First install the packages needed (kubeadm, Docker, Kubectl ) on both master and Node machine using  --> ansible-playbook kube-dependencies.yml
5.Initiatize kubernetes master and copy the config to the .kube folder  -->ansible-playbook k8s-master.yml
6.Join the Slave nodes to the master with the join token variable from master host.   -->ansible-playbook k8s-workers.yml
7.Follow the steps inside --> Scripts/dashboard.sh to install the dashboard, create service account and provide prevelage to access the dashboard with the token denerated.
8.Follow the steps inside --> Scripts/helm.sh to install helm 3 on the machine and add helm repo to the clsuter and to perform Ingress Controller.
9.Execute the steps under --> Loadbalancer/loadbalancer.sh to download metallb and install pods,serviceaccounts,deployments,roles,rolebindings under metallb-system namesapce to provide Loadbalancer ip to the service.
10.Execute the scriptes under --> SampleService/sample.sh to install a demo application pod,svc and ingress file to map the DNS for the demo as demo.example.com.

For deployment of all multiple production microserice images using automation provided a script under -->Microservice/deployment.sh
    1.Make a enry to the input.json file with deployments and Images of productions available.
    2.Verify the generic-template.yaml based on your microservices kubernetes yaml file.
    3.Execute deployment.sh script to parse input key value from input.json file to the generic yaml and perform and remove to the n key values available in json input.
    

Provided with the Jenkins script to execute the complete above process in stages using jenkins pipeline.
node()
	Stage('Checkout'){
		sh'''
			checkout([$class: 'GitSCM', branch: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir:'kubernetes']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '*** jenkins credentals ID ***', url: 'https://github.com/jeba4all/Prodapt_Poc.git']]])
		  '''
		  }
		  
	Stage('Kubernetes Cluster Creation'){
		sh'''
			cd $WORKSPACE/kubernetes/Ansible
			ansible-playbook kube-dependencies.yml
			ansible-playbook k8s-master.yml
			ansible-playbook k8s-workers.yml
			'''
			}
			
	Stage('Dashboard for Service and Cluster metrics'){
		sh'''
			kubectl -n kube-system create sa dashboard
			kubectl create clusterrolebinding dashboard --clusterrole cluster-admin --serviceaccount=kube-system:dashboard
			kubectl -n kube-system get sa dashboard -o yaml
			kubectl -n kube-system describe secrets dashboard-token-
			kubectl proxy &
			'''
			)
	
	stage('Helm Installation & Ingress Package')(
		sh'''
			curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
			chmod 700 get_helm.sh
			./get_helm.sh
			helm version
			helm repo add nginx-stable https://helm.nginx.com/stable
			helm repo update
			helm install my-release nginx-stable/nginx-ingress
			'''
			}
		
	stage('LoadBalacer MetalLB'){
		sh'''
			cd $WORKSPACE/kubernetes/LoadBalacer
			kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/namespace.yaml
			kubectl get ns
			kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml
			kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
			kubectl get all -n metallb-system
			kubectl apply -f config.yaml
			'''
			}
			
	Stage('yamllint & kubeval Test'){
		sh'''
			cd $WORKSPACE/kubernetes/SampleService
			kubeval sample.yml
			yamllint sample.yml
			'''
			)
			
	Stage('sample Demo Service'){
		sh'''
			cd $WORKSPACE/kubernetes/SampleService
			kubectl apply -f sample.yml
			kubectl get ingress --namespace demo
			kubectl get svc --namespace demo
			}
	}
