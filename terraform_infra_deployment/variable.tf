variable "access_key" {
    type      = string
    default   = "XXXX"
    sensitive = true
}

variable "secret_key" {
    type      = string
    default   = "XXXX"
    sensitive = true
}

variable "region" {
    type    = string
    default = "us-east-1"
}