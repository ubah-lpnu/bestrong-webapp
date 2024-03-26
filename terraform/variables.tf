variable "ARM_CLIENT_ID" {
  type        = string
  description = "The client id for azure account."

}

variable "ARM_CLIENT_SECRET" {
  type        = string
  description = "The client secret for azure account."

}

variable "ARM_TENANT_ID" {
  type        = string
  description = "The tenant id for azure account."

}

variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "The subscription id for azure account."

}

variable "docker_image_name" {
  type        = string
  description = "The docker image name."
  
}