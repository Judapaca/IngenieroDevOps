# Crear el bucket S3
resource "aws_s3_bucket" "bucket" {
  bucket = "mi-bucket-ejemplo-lambda-s3"
}

# Crear la función Lambda
resource "aws_lambda_function" "lambda" {
  function_name = "lambda_desde_s3"

  filename         = "lambda_function_payload.zip" # Zip de tu código
  handler          = "index.handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn

  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

# Crear el rol IAM para Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-s3-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Permisos necesarios para Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-s3-access"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Permiso para que S3 invoque la Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}

# Configura el evento de subida de archivos en S3 que dispare la Lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}