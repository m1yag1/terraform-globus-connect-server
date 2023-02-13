resource "aws_secretsmanager_secret" "gcsv5_user_access_key_id" {
    name = "${module.iam_user.iam_user_name}_access_key_id"
    recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gcsv5_user_access_key_id_version" {
  secret_id = aws_secretsmanager_secret.gcsv5_user_access_key_id.id
  secret_string = module.iam_user.iam_access_key_id
}

resource "aws_secretsmanager_secret" "gcsv5_user_access_key" {
    name = "${module.iam_user.iam_user_name}_access_key"
    recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gcsv5_user_access_key_version" {
  secret_id = aws_secretsmanager_secret.gcsv5_user_access_key.id
  secret_string = module.iam_user.iam_access_key_secret 
}
