up:
	terraform plan -out main.tfplan
	terraform apply main.tfplan

connect:
	ssh -i ./private_key_rsa azureadmin@$(public_ip)

destroy:
	terraform plan -destroy -out main.destroy.tfplan
	terraform apply main.destroy.tfplan
