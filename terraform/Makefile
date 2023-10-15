up:
	terraform plan -out main.tfplan
	terraform apply main.tfplan

connect:
	ssh -i ./private_rsa_key azureadmin@$(public_ip)

destroy:
	terraform plan -destroy -out main.destroy.tfplan
	terraform apply main.destroy.tfplan
