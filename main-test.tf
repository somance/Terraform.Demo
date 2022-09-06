provider "azurerm" {
  features {}
}



resource "azurerm_resource_group" "JobDemo1" {
  name     = var.appservicename
  location = var.location
}

resource "azurerm_service_plan" "JobDeployDemoASP" {
  location = azurerm_resource_group.JobDemo1.location
  name = "JobDeployDemoASP"
  resource_group_name = azurerm_resource_group.JobDemo1.name
  sku {
    size = "S1"
    tier = "Standard"
  }
}

resource "azurerm_app_service" "JobDeployDemo" {
  name = "JobDeployDemo"
  location = azurerm_resource_group.JobDemo1.location
  resource_group_name = azurerm_resource_group.JobDemo1.name
  app_service_plan_id =  azurerm_service_plan.JobDeployDemoASP.id

  site_config {
    dotnet_framework_version = "v5.0"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2022"
  }
  backup {
    name = "Jobdemobackup"
    storage_account_url = "https://webappjobdemostorage.blob.core.windows.net/backup?sv=2021-06-08&ss=bfqt&srt=c&sp=rwdlacupiytfx&se=2022-09-06T15:56:41Z&st=2022-09-06T07:56:41Z&spr=https&sig=0iWiVRlX8NzXML3PcBDanN%2BlgXDQE9PnygY%2Fo7RAeEU%3D&sr=b"
    schedule {
      frequence_interval = 30
      frequency_unit = "Day"
    }
  }
}
