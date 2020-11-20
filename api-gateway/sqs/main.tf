resource "aws_api_gateway_resource" "sqs_proxy" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = var.path
}

resource "aws_api_gateway_method" "method_sqs_proxy" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.sqs_proxy.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = false
  }
}

resource "aws_api_gateway_integration" "api" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.sqs_proxy.id
  http_method             = aws_api_gateway_method.method_sqs_proxy.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  credentials             = module.apigw_role.arn
  uri                     = "arn:aws:apigateway:${var.region}:sqs:path/${var.sqs_queue_name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/x-www-form-urlencoded" = <<EOF
Action=SendMessage&MessageBody={
  "method": "$context.httpMethod",
  "base64body": "$util.base64Encode($input.body)",
  "headers": {
    #foreach($param in $input.params().header.keySet())
    "$param": "$util.escapeJavaScript($input.params().header.get($param))" #if($foreach.hasNext),#end
  #end
  },
  "queryParams": {
    #foreach($param in $input.params().querystring.keySet())
    "$param": "$util.escapeJavaScript($input.params().querystring.get($param))" #if($foreach.hasNext),#end
  #end
  },
  "pathParams": {
    #foreach($param in $input.params().path.keySet())
    "$param": "$util.escapeJavaScript($input.params().path.get($param))" #if($foreach.hasNext),#end
    #end
  }
}
EOF
  }
}

resource "aws_api_gateway_method_response" "http200" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.sqs_proxy.id
  http_method = aws_api_gateway_method.method_sqs_proxy.http_method
  status_code = 200
}

resource "aws_api_gateway_integration_response" "http200" {
  rest_api_id       = var.rest_api_id
  resource_id       = aws_api_gateway_resource.sqs_proxy.id
  http_method       = aws_api_gateway_method.method_sqs_proxy.http_method
  status_code       = aws_api_gateway_method_response.http200.status_code
  selection_pattern = "^2[0-9][0-9]" // regex pattern for any 200 message that comes back from SQS

  depends_on = [
    aws_api_gateway_integration.api,
  ]
}
