resource "aws_eip" "gitlab-aws_eip" {
  network_border_group = "us-east-1"
  tags = {
    "Name" = "GitLab-IP"
  }
}
