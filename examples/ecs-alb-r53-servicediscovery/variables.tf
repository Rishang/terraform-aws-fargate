variable "certificate_domain" {
  description = "The domain name of the aws certificate manager eg: example.com"
  type        = string
}

variable "extra_certificate_domains" {
  description = "The extra domain names to add to the certificate eg: [\"example.com\", \"www.example.com\"]"
  type        = list(string)
  default     = []
}

variable "EnvironmentName" {
  type = string
}

variable "alb_name" {
  type = string
}

variable "subdomain" {
  type = string
}