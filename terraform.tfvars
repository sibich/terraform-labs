location                = "westeurope"

tags                    = {
                    env = "staging"
}

ResourceGroup           = "resourcegrouptf"

vm                      = "tfvm03"
vmsize                  = "Standard_B2s"
vmpublisher             = "MicrosoftWindowsServer"
offer                   = "WindowsServer"
sku                     = "2019-Datacenter"
ostype                  = "windows"

hostname                = "terravm"
LocalAdmin              = "vitaly"
LocalSrvAccSecret       = "P@ssword"

vnetname                = "Vnet03"
VNetAddressPrefix       = "172.16.0.0/16"
subnetname              = "Subnet"
VNetSubnetAddressPrefix = "172.16.1.0/24"
InterfaceName           = "net03"
publicIpName            = "terra-pip"
fqdn                    = "sibich"

NetworkSecurityGroup    = "tfnrg"

StorageAccount          = "sibichstorage03"
StorageContainer        = "vhds"
StorageAccountTier      = "Standard"
StorageAccountRepType   = "LRS"

