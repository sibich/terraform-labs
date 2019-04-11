variable "ResourceGroup" {
    default = "terraform-rg"
}

variable "location" {
    default = "West Europe"
}

variable "tags" {
    type = "map"
    default = {
        environment = "training"
        }
}

variable "vm" {
    default = "tfvm"
}
variable "vmsize" {
    default = "Standard_B2ms"
}
variable "vmpublisher" {
    default = "MicrosoftWindowsServer"
}
variable "offer" {
    default = "WindowsServer"
}
variable "sku" {
    default = "2016-Datacenter"
}
variable "ostype" {
    default = "windows"
}
variable "hostname" {
    default = "terravm"
}
variable "LocalAdmin" {
    default = "Wvitaly"
}
variable "LocalSrvAccSecret" {
    default = "P@ssword"
}
variable "vnetname" {
    default = "Vnet"
}
variable "VNetAddressPrefix" {
    default = "172.16.0.0/16"
}
variable "subnetname" {
    default = "Subnet"
}
variable "VNetSubnetAddressPrefix" {
    default = "172.16.1.0/24"
}
variable "InterfaceName" {
    default = "net"
}
variable "publicIpName" {
    default = "pip"
}
variable "fqdn" {
    default = "local"
}
variable "NetworkSecurityGroup" {
    default = "nrg"
}
variable "StorageAccount" {
    default = "sibichstorage"
}

variable "StorageContainer" {
    default = "sibichcontainer"
}

variable "StorageAccountTier" {
    default = "Standard"
}
variable "StorageAccountRepType" {
    default = "LRS"
}
