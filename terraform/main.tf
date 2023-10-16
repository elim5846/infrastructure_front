resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_pet" "rg_name_db" {
  prefix = var.resource_group_name_prefix_db
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "azurerm_resource_group" "rg_db" {
  location = var.resource_group_location_db
  name     = random_pet.rg_name_db.id
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network_db" {
  name                = "myVnetDb"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_db.location
  resource_group_name = azurerm_resource_group.rg_db.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet_db" {
  name                 = "mySubnetDb"
  resource_group_name  = azurerm_resource_group.rg_db.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network_db.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  count               = 2
  name                = "myPublicIP-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip_back" {
  name                = "myPublicIPBack"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip_db" {
  name                = "myPublicIPDb"
  location            = azurerm_resource_group.rg_db.location
  resource_group_name = azurerm_resource_group.rg_db.name
  allocation_method   = "Dynamic"
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip_db_rep" {
  name                = "myPublicIPDbRep"
  location            = azurerm_resource_group.rg_db.location
  resource_group_name = azurerm_resource_group.rg_db.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 901
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg_back" {
  name                = "myNetworkSecurityGroupBack"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-BACK"
    priority                   = 951
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg_db" {
  name                = "myNetworkSecurityGroupDb"
  location            = azurerm_resource_group.rg_db.location
  resource_group_name = azurerm_resource_group.rg_db.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-DB"
    priority                   = 951
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg_db_rep" {
  name                = "myNetworkSecurityGroupDbRep"
  location            = azurerm_resource_group.rg_db.location
  resource_group_name = azurerm_resource_group.rg_db.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-DB"
    priority                   = 951
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  count               = 2
  name                = "myNIC-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration-${count.index}"
    subnet_id                     = element(azurerm_subnet.my_terraform_subnet[*].id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.my_terraform_public_ip[*].id, count.index)
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic_back" {
  name                = "myNICBack"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration_back"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip_back.id
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic_db" {
  name                = "myNICDb"
  location            = azurerm_resource_group.rg_db.location
  resource_group_name = azurerm_resource_group.rg_db.name

  ip_configuration {
    name                          = "my_nic_configuration_db"
    subnet_id                     = azurerm_subnet.my_terraform_subnet_db.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip_db.id
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic_db_rep" {
  name                = "myNICDbRep"
  location            = azurerm_resource_group.rg_db.location
  resource_group_name = azurerm_resource_group.rg_db.name

  ip_configuration {
    name                          = "my_nic_configuration_db_rep"
    subnet_id                     = azurerm_subnet.my_terraform_subnet_db.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip_db_rep.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  count                     = 2
  network_interface_id      = element(azurerm_network_interface.my_terraform_nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "exampleBack" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic_back.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg_back.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "exampleDb" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic_db.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg_db.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "exampleDbRep" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic_db_rep.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg_db_rep.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_file" {
  content         = tls_private_key.tlskey.private_key_pem
  filename        = "private_key_rsa"
  file_permission = 0600
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_back" {
  name                  = "myVMBack"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic_back.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDiskBack"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostnameBack"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.tlskey.public_key_openssh
  }

  connection {
    host        = self.public_ip_address
    user        = var.username
    type        = "ssh"
    private_key = tls_private_key.tlskey.private_key_pem
    timeout     = "30m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "export PRIVATE_IP=${self.private_ip_address}",
      "export POSTGRES_USER=docker",
      "export POSTGRES_PASSWORD=docker",
      "export POSTGRES_HOST=${azurerm_linux_virtual_machine.my_terraform_db.public_ip_address}",
      "export POSTGRES_DB=todo_db",
      "git clone https://github.com/elim5846/infrastructure_front.git",
      "cd infrastructure_front",
      "./script_back.sh"
    ]
  }
}

# Create virtual machine
/*
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  count                 = 2
  name                  = "myVM-${count.index}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = ["${element(azurerm_network_interface.my_terraform_nic.*.id, count.index)}"]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.tlskey.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

  connection {
    host        = self.public_ip_address
    user        = var.username
    type        = "ssh"
    private_key = tls_private_key.tlskey.private_key_pem
    timeout     = "30m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "export NEXT_PUBLIC_NODE_BACK_URL=http://${azurerm_linux_virtual_machine.my_terraform_back.public_ip_address}:3000/todo",
      "git clone https://github.com/elim5846/infrastructure_front.git",
      "cd infrastructure_front",
      "./script_front.sh",
    ]
  }
}
*/

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_db" {
  name                  = "myVMDb"
  location              = azurerm_resource_group.rg_db.location
  resource_group_name   = azurerm_resource_group.rg_db.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic_db.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDiskDb"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostnameDb"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.tlskey.public_key_openssh
  }

  connection {
    host        = self.public_ip_address
    user        = var.username
    type        = "ssh"
    private_key = tls_private_key.tlskey.private_key_pem
    timeout     = "30m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/elim5846/infrastructure_front.git",
      "cd infrastructure_front",
      "./script_postgres.sh"
    ]
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_db_replicate" {
  name                  = "myVMDbRep"
  location              = azurerm_resource_group.rg_db.location
  resource_group_name   = azurerm_resource_group.rg_db.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic_db_rep.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDiskDbRep"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostnameDbRep"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.tlskey.public_key_openssh
  }

  connection {
    host        = self.public_ip_address
    user        = var.username
    type        = "ssh"
    private_key = tls_private_key.tlskey.private_key_pem
    timeout     = "30m"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "export MAIN_DB_IP=${azurerm_linux_virtual_machine.my_terraform_db.private_ip_address}",
      "git clone https://github.com/elim5846/infrastructure_front.git",
      "cd infrastructure_front",
      "./script_postgres_replicate.sh"
    ]
  }
}