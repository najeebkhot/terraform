variable "access_key" {
    type      = string
    default   = "AKIATH4VPSGQVZBN4T6V"
    sensitive = true
}

variable "secret_key" {
    type      = string
    default   = "sFTwbS2+rLT0Fg3iWerdORfu0u2Pg5CS6idZDOUa"
    sensitive = true
}

variable "region" {
    type    = string
    default = "us-east-2"
}

variable "iam_users" {
    type = "list"
    default = ["jane","john","jacob"]
}