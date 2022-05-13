resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.cluster_name}-${var.environment}-key"
  public_key = tls_private_key.dev_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.cluster_name}'-'${var.environment}'-key.pem
    EOT
  }

}
