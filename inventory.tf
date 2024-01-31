resource "local_sensitive_file" "private_key" {
  content         = var.PRIVATE_KEY_CONTENT
  filename        = format("%s/%s/%s", abspath(path.cwd), "ansible", "jenkins-key.pem")
  file_permission = "0400"
}
