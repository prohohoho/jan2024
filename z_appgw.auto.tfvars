appgw_config = {
  ddhprdappgateway = {
    vnet_name     = "ddhaeastprodvnet"
    subnet_name   = "ddhaeastprodappgwysubnet"
    cert_pass     = "kalpesh@123"
    
    ###Specify values for the following variables if has keyvault storage for cert
    #keyvault_name = "testonlys"    
    #secret_name   = "ddhaeastprodappgwcert"
    
    ###set to true if you want to create a https listener
    hashttpslistner = true
  }
}


