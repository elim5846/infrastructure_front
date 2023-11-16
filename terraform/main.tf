resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_pet" "rg_name_db" {
  prefix = var.resource_group_name_prefix_db
}

resource "random_pet" "rg_name_front" {
  prefix = var.resource_group_name_prefix_front
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "azurerm_resource_group" "rg_front" {
  location = var.resource_group_location_front
  name     = random_pet.rg_name_front.id
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

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network_front" {
  name                = "myVnetFront"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_front.location
  resource_group_name = azurerm_resource_group.rg_front.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet_front" {
  name                 = "mySubnetFront"
  resource_group_name  = azurerm_resource_group.rg_front.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network_front.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "my_terraform_public_ip_front" {
  name                = "myPublicIPFrontVmss"
  location            = azurerm_resource_group.rg_front.location
  resource_group_name = azurerm_resource_group.rg_front.name
  allocation_method   = "Static"
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip_back" {
  name                = "myPublicIPBack"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
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
  location            = azurerm_resource_group.rg_front.location
  resource_group_name = azurerm_resource_group.rg_front.name

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
resource "azurerm_network_interface_security_group_association" "exampleDb" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic_db.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg_db.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "exampleDbRep" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic_db_rep.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg_db_rep.id
}

resource "azurerm_lb" "vmss_front" {
 name                = "vmss_lb_front"
 location            = azurerm_resource_group.rg_front.location
 resource_group_name = azurerm_resource_group.rg_front.name

 frontend_ip_configuration {
   name                 = "PublicIPAddressLbFront"
   public_ip_address_id = azurerm_public_ip.my_terraform_public_ip_front.id
 }
}

resource "azurerm_lb_backend_address_pool" "bpepool_front" {
 loadbalancer_id     = azurerm_lb.vmss_front.id
 name                = "FrontEndAddressPool"
}

resource "azurerm_lb_probe" "vmss_front" {
 resource_group_name = azurerm_resource_group.rg_front.name
 loadbalancer_id     = azurerm_lb.vmss_front.id
 name                = "ssh-running-probe"
 port                = var.front_port
}

resource "azurerm_lb_rule" "lbnatrule_front" {
   resource_group_name            = azurerm_resource_group.rg_front.name
   loadbalancer_id                = azurerm_lb.vmss_front.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.front_port
   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool_front.id]
   frontend_ip_configuration_name = "PublicIPAddressLbFront"
   probe_id                       = azurerm_lb_probe.vmss_front.id
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss_front" {
  name                = "vmss-front"
  resource_group_name = azurerm_resource_group.rg_front.name
  location            = azurerm_resource_group.rg_front.location
  sku                 = "Standard_DS1"
  instances           = 1
  admin_username      = var.username
  upgrade_mode        = "Manual"

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.tlskey.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name = "myNIC_Front"
    primary = true
    network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id

    ip_configuration {
      name      = "my_nic_configuration_front"
      primary   = true
      subnet_id = azurerm_subnet.my_terraform_subnet_front.id
      public_ip_address {
        name = "vmss_front_public_ip"
      }
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool_front.id]
    }
  }

 lifecycle {
    ignore_changes = [instances]
  }

  extension {
    name                         = "frontExtVmss"
    publisher                    = "Microsoft.Azure.Extensions"
    type                         = "CustomScript"
    type_handler_version         = "2.0"
    settings = jsonencode({
      "commandToExecute" = "export NEXT_PUBLIC_NODE_BACK_URL=http://${azurerm_public_ip.my_terraform_public_ip_back.ip_address}/todo && git clone https://github.com/elim5846/infrastructure_front.git && cd infrastructure_front && ./script_front.sh"
      //"commandToExecute" = "echo ok"
    })
  }
}

resource "azurerm_monitor_autoscale_setting" "front_settings" {
  name                = "myAutoscaleSettingFront"
  resource_group_name = azurerm_resource_group.rg_front.name
  location            = azurerm_resource_group.rg_front.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss_front.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss_front.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss_front.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["eric.lim@epita.fr", "lenoic.cramon@epita.fr", "leo.mermet@epita.fr", "dorian.mignong@epita.fr", "guillaume.avril@epita.fr"]
    }
  }
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
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

resource "azurerm_lb" "vmss_back" {
 name                = "vmss_lb_back"
 location            = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name

 frontend_ip_configuration {
   name                 = "PublicIPAddressLbBack"
   public_ip_address_id = azurerm_public_ip.my_terraform_public_ip_back.id
 }
}

resource "azurerm_lb_backend_address_pool" "bpepool_back" {
 loadbalancer_id     = azurerm_lb.vmss_back.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss_back" {
 resource_group_name = azurerm_resource_group.rg.name
 loadbalancer_id     = azurerm_lb.vmss_back.id
 name                = "ssh-running-probe"
 port                = var.backend_port
}

resource "azurerm_lb_rule" "lbnatrule_back" {
   resource_group_name            = azurerm_resource_group.rg.name
   loadbalancer_id                = azurerm_lb.vmss_back.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.backend_port
   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool_back.id]
   frontend_ip_configuration_name = "PublicIPAddressLbBack"
   probe_id                       = azurerm_lb_probe.vmss_back.id
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss_back" {
  name                = "vmss-back"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_DS1_v2"
  instances           = 1
  admin_username      = var.username
  upgrade_mode        = "Manual"

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.tlskey.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name = "myNIC_Back"
    primary = true
    network_security_group_id = azurerm_network_security_group.my_terraform_nsg_back.id

    ip_configuration {
      name      = "my_nic_configuration_back"
      primary   = true
      subnet_id = azurerm_subnet.my_terraform_subnet.id
      public_ip_address {
        name = "vmss_back_public_ip"
      }
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool_back.id]
    }
  }

 lifecycle {
    ignore_changes = [instances]
  }

  extension {
    name                         = "frontExtVmss"
    publisher                    = "Microsoft.Azure.Extensions"
    type                         = "CustomScript"
    type_handler_version         = "2.0"
    settings = jsonencode({
      // export PRIVATE_IP=${self.private_ip_address} &&
      "commandToExecute" = "export POSTGRES_USER=docker && export POSTGRES_HOST_REPLICATE=${azurerm_linux_virtual_machine.my_terraform_db_replicate.public_ip_address} && export POSTGRES_PASSWORD=docker && export POSTGRES_HOST=${azurerm_linux_virtual_machine.my_terraform_db.public_ip_address} && export POSTGRES_DB=todo_db && git clone https://github.com/elim5846/infrastructure_front.git && cd infrastructure_front && ./script_back.sh"
    })
  }
}

resource "azurerm_monitor_autoscale_setting" "back_settings" {
  name                = "myAutoscaleSettingBack"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss_back.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss_back.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss_back.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["eric.lim@epita.fr", "lenoic.cramon@epita.fr", "leo.mermet@epita.fr", "dorian.mignong@epita.fr", "guillaume.avril@epita.fr"]
    }
  }
}

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