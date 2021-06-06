WORKSPACE=/home/ajaijebakumar/Prodapt_Poc/Microservice
cd $WORKSPACE
jq -c '.[]' input.json | while read i; do
cp generic-template.yaml service.yaml
dep=`echo ${i} | jq -r '.DEPLOYMENTNAME'`
img=`echo ${i} | jq -r '.IMAGENAME'`
			              
echo $dep
echo $img
					               
cat service.yaml | sed -e "s|%DEPLOYMENTNAME%|'${dep}'|g; s|%IMAGENAME%|'${img}'|g"  > templatenew.yaml
						                
kubectl create -f $WORKSPACE/templatenew.yaml
				         
cd $WORKSPACE
rm -rf service.yaml
rm -rf templatenew.yaml
done
sleep 100
kubectl get svc -o=wide
