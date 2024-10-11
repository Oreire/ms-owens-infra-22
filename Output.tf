output "Frontend_server_public_ip" {
  value = aws_instance.Frontend_server.public_ip
}

output "Frontend_server_public_dns" {
  value = aws_instance.Frontend_server.public_dns
}

output "Frontend_server2_public_ip" {
  value = aws_instance.Frontend_server2.public_ip
}

output "Backend_server_public_ip" {
  value = aws_instance.Backend_server.public_ip
}

output "Backend_server2_public_ip" {
  value = aws_instance.Backend_server2.public_ip
}

output "Backend_server2_public_dns" {
  value = aws_instance.Backend_server2.public_dns
}
output "Database_server_public_ip" {
  value = aws_instance.Database_server.public_ip
}

