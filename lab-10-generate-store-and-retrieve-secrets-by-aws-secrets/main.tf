
provider "aws" {
  region = "ca-central-1"
}

# ------------------------------------------------------------------------------

resource "aws_db_instance" "prod" {
  identifier           = "prod-mysql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "administrator"
  password             = data.aws_secretsmanager_secret_version.rds_password.secret_string
}

# password generator -----------------------------------------------------------

resource "random_password" "main" {
  length           = 20
  special          = true
  override_special = "#!()_"
}


# aws secrets ------------------------------------------------------------------


resource "aws_secretsmanager_secret" "rds_password" {
  name                    = "/prod/rds/password"
  description             = "password for my RDS database"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.main.result
  depends_on    = [random_password.main]
}

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id  = aws_secretsmanager_secret.rds_password.id
  depends_on = [aws_secretsmanager_secret_version.rds_password]
}

resource "aws_secretsmanager_secret" "rds" {
  name                    = "/prod/rds/all"
  description             = "all data for my RDS database"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    rds_address  = aws_db_instance.prod.address
    rds_port     = aws_db_instance.prod.port
    rds_username = aws_db_instance.prod.username
    rds_password = random_password.main.result
  })
  depends_on = [random_password.main]
}


# data -------------------------------------------------------------------------

data "aws_secretsmanager_secret_version" "rds" {
  secret_id  = aws_secretsmanager_secret.rds.id
  depends_on = [aws_secretsmanager_secret_version.rds]
}

# outputs ----------------------------------------------------------------------

output "rds_address" {
  value = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_address"])
}

output "rds_port" {
  value = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_port"])
}

output "rds_username" {
  value = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_username"])
}

output "rds_password" {
  value = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["rds_password"])
}

output "rds_all" {
  value = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string))
}
