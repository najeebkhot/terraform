#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "webserver-key" {
    key_name   = "webserver-key"
    public_key = file("~/.ssh/id_rsa.pub")
}