# OCI text-generation-webui
Terraform scripts for running [text-generation-webui](https://github.com/oobabooga/text-generation-webui) on a NVIDIA GPU in Oracle Cloud Infrastructure (OCI). 

You can use different LLMs to geneerate text:

- Pythia
- OPT
- GALACTICA
- GPT-J 6B
- Vicuna

This scripts automatically install the model [vicuna](https://huggingface.co/anon8231489123/vicuna-13b-GPTQ-4bit-128g).

## Requirements
- Terraform
- ssh-keygen

## Configuration

1. Follow the instructions to add the authentication to your tenant https://medium.com/@carlgira/install-oci-cli-and-configure-a-default-profile-802cc61abd4f.

2. Clone this repository
```bash
    git https://github.com/carlgira/oci-text-generation-webui.git
```

3. Set three variables in your path. 
- The tenancy OCID, 
- The comparment OCID where the instance will be created.
- The "Region Identifier" of region of your tenancy. 
> **Note**: [More info on the list of available regions here.](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm)

```bash
    export TF_VAR_tenancy_ocid='<tenancy-ocid>'
    export TF_VAR_compartment_ocid='<comparment-ocid>'
    export TF_VAR_region='<home-region>'
```

4. Execute the next command to generate private key to access the instance
```bash
    ssh-keygen -t rsa -b 2048 -N "" -f server.key
```

## Build
To build simply execute the next commands. 
```bash
    terraform init
    terraform plan
    terraform apply
```
## Test
To test everything you need to create a ssh tunel to the port 7860

```bash
    ssh -i server.key -L 7860:localhost:7860 opc@<instance-public-ip>
```

Open the URL https://localhost:7860, and you can see the gradio app running.

## Clean
To delete the instance execute.
```bash
    terraform destroy
```

## Troubleshooting
If you found some problem check if the services are down. You can check the logs and the state of each app, with the commands.

```bash
    systemctl status text-generation-webui.service
```

## Acknowledgements

* **Author** - [Carlos Giraldo](https://www.linkedin.com/in/carlos-giraldo-a79b073b/), Oracle
* **Last Updated Date** - April 8, 2023