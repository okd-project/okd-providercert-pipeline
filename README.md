# OKD Openshift Tekton provider-certification-tool pipeline for Kind 

## Intro

This is a simple POC project to execute a complete provider certification pipeline on a kind cluster.
Please refer to the upstream project https://github.com/redhat-openshift-ecosystem/provider-certification-tool 

**NB** This is still a WIP 

## Description

A simple set of Tekton yaml files that add the relevant steps to create an ease of use scenario for ops/devs needing to certify an okd/openshift cluster

### Clone the repository and build

```bash
git clone git@github.com:lmzucarelli/tekton-providercert-pipeline

cd tekton-providercert-pipeline
kd

```

## Usage

This assumes that Kind is up and running and Tekton pipelines have been deployed

Execute the following commands


```bash
# create the provider-certification namespace
kubectl create ns provider-certification

# change the storage class depending on the cluster
kubectl get storageclass

# update the patch file with the value obtained from previous step
# manifests/tekton/utility/base/patches/patch-pvc-storageclass.yaml

# deploy the manifests (pipeline and tasks)
kubectl apply -k environment/overlay/cicd

# use the copy feature in kubectl to copy the relevant KUBECONFIG file to the mount point /tmp
# as an example
kubectl -n provider-certifification ~/.kube debug-pod:/tmp

```

Launch the pipeline

Using kubelet apply 

```bash

# update the pipelinerun file (change values)
# ${CLUSTER_NAME} and ${PVC_NAME}
# manifests/tekton/pipelineruns/sample-pr-kind.yaml
kubectl apply -f manifests/tekton/pipelineruns/sample-pr-kind.yaml

```

Using the tkn start command

```bash

# this will use the pvc that has already been created
tkn pipeline start provider-certification \
--param cluster-name=<cluster-to-be-certified> \
-n provider-certification

```

Watch the pipeline logs

```bash

tkn pr list -n provider-certification
tkn pr logs <pr-name-from-previous-step> -n provider-certifification -f
```

## Info

A docker file is included in this repository that includes the provider-certification-tool binary.
To build from scratch clone the repository https://github.com/redhat-openshift-ecosystem/provider-certification-tool 

execute the following

```bash
cd provider-certifification-tool

make clean
make build

```

Copy the binary to this working directory (tekton-providercert-pipeline)

Use your preferred container build tool to build and push to a container registry using the Dockerfile in this repository
 

