azurerm_resource_group_template_deployment.elastic_cluster: Still creating... [1m30s elapsed]
╷
│ Error: waiting for creation of Template Deployment "elastic_cluster" (Resource Group "jhg"): Code="DeploymentFailed" Message="At least one resource deployment operation failed. Please list deployment operations for details. Please see https://aka.ms/arm-deployment-operations for usage details." Details=[{"code":"Conflict","message":"{\r\n  \"status\": \"Failed\",\r\n  \"error\": {\r\n    \"code\": \"ResourceDeploymentFailure\",\r\n    \"message\": \"The resource write operation failed to complete successfully, because it reached terminal provisioning state 'Failed'.\",\r\n    \"details\": [\r\n      {\r\n        \"code\": \"ClusterDoesNotExist\",\r\n        \"message\": \"Cluster jhg-pgfs-01 does not exist for subscription 743b758a-f6e7-4823-b706-950a64a6c9f9 resource group jhg\"\r\n      }\r\n    ]\r\n  }\r\n}"}]
│
│   with azurerm_resource_group_template_deployment.elastic_cluster,
│   on elastic_cluster.tf line 24, in resource "azurerm_resource_group_template_deployment" "elastic_cluster":
│   24: resource "azurerm_resource_group_template_deployment" "elastic_cluster" {
│
