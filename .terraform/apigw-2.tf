resource "aws_apigatewayv2_integration" "lambda_handler" {
  api_id = aws_apigatewayv2_api.main.id

  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.printIP.invoke_arn
}

resource "aws_apigatewayv2_route" "get_printIP" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /printIP"

  target = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.printIP.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
