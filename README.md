# OKD Openshift Tekton provider-certification-tool pipeline for Kind/OCP/OKD clusters

## Intro

This is a simple POC project to execute a complete provider certification pipeline on a kind cluster.
Please refer to the upstream project https://github.com/redhat-openshift-ecosystem/provider-certification-tool 

**NB** This is still a WIP 

## Description

A simple set of Tekton yaml files that add the relevant steps to create an ease of use scenario for ops/devs needing to certify an okd/openshift cluster

### Clone the repository and build

N.B. The pre-requisite is to clone the repo https://github.com/redhat-openshift-ecosystem/provider-certification-tool

Follow the instructions on compiling/building and copy the binary to the working directory in the instructions that follow

A Dockerfile is provided to include the binary, build and push to a registry of your choice

```bash
git clone git@github.com:okd-providercert-pipeline

cd okd-providercert-pipeline


```

## Usage

This assumes that Kind/Cluster is up and running and Tekton pipelines have been deployed

Execute the following commands


```bash
# create the provider-certification namespace
kubectl create ns provider-certification

# change the storage class depending on the cluster
kubectl get storageclass

# update the patch file with the value obtained from previous step
# base/apps/utility/base/patches/patch-pvc-storageclass.yaml

# change the image reference in the file base/tekton.dev/tasks/base/task-execute-all.yaml
# to the registry you pushed the image to 

# deploy the manifests (pipeline and tasks)
kubectl apply -k overlay/

# use the copy feature in kubectl to copy the relevant KUBECONFIG file to the mount point /tmp
# as an example
kubectl -n provider-certifification ~/.kube debug-pod:/tmp

```

Launch the pipeline

Using kubelet apply 

```bash

# update the pipelinerun file (change values)
# ${CLUSTER_NAME} and ${PVC_NAME}
# base/tekton.dev/pipelineruns/sample-pr-kind.yaml
kubectl apply -f base/tekton.dev/pipelineruns/sample-pr-kind.yaml

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
 

