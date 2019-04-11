location                = "westeurope"

tags                    = {
                    env = "staging"
}

ResourceGroup           = "resourcegroup02"

vm                      = "tfvm02"
vmsize                  = "Standard_B2ms"
vmpublisher             = "MicrosoftWindowsServer"
offer                   = "WindowsServer"
sku                     = "2016-Datacenter"
ostype                  = "windows"

hostname                = "terravm"
LocalAdmin              = "vitaly"
LocalSrvAccSecret       = "P@ssword"

vnetname                = "Vnet02"
VNetAddressPrefix       = "172.16.0.0/16"
subnetname              = "Subnet"
VNetSubnetAddressPrefix = "172.16.1.0/24"
InterfaceName           = "net02"
publicIpName            = "terra-pip"
fqdn                    = "sibich"

NetworkSecurityGroup    = "tfnrg"

StorageAccount          = "sibichstorage02"
StorageContainer        = "vhds"
StorageAccountTier      = "Standard"
StorageAccountRepType   = "LRS"

