provider "aws" {
   region = "us-east-1"
}
locals{
   lambda_zip_locations = "output/create.zip"
}
data "archive_file" "list" {
   type        = "zip"
   source_file = "create.py"
   output_path = local.lambda_zip_locations
}
resource "aws_dynamodb_table" "table_test" {
   name             = "table_test"
   hash_key         = "todo_id"
   billing_mode   = "PROVISIONED"
   read_capacity  = 3
   write_capacity = 3
   attribute {
     name = "todo_id"
     type = "S"
   }
}
resource "aws_iam_role" "lambda_role" {
   name = "lambda_role"
   assume_role_policy = file("assume_role_policy.json")
}
resource "aws_iam_role_policy" "lambda_policy" {
   name = "lambda_policy"
   role = aws_iam_role.lambda_role.id
   policy = file("policy.json")
}
resource "aws_lambda_function" "Lambda_test" {
   function_name = "create_item"
   filename      = local.lambda_zip_locations
   role          = aws_iam_role.lambda_role.arn
   handler       = "create.handler"
   runtime       = "python2.7"
}