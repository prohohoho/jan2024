output "sqlpass" {
  description = "Returns all the subnets objects in the Virtual Network. As a map of keys, ID"
  value       = random_password.password.result
}