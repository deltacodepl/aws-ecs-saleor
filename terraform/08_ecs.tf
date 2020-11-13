resource "aws_ecs_cluster" "production" {
  name = "${var.ecs_cluster_name}-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${var.ecs_cluster_name}-cluster"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  key_name                    = aws_key_pair.production.key_name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}-cluster' > /etc/ecs/ecs.config"
}

data "template_file" "app" {
  template = file("templates/saleor_app.json.tpl")

  vars = {
    docker_image_url_django = var.docker_image_url_django
    docker_image_url_nginx  = var.docker_image_url_nginx
    region                  = var.region
    rds_db_name             = var.rds_db_name
    rds_username            = var.rds_username
    rds_password            = var.rds_password
    rds_hostname            = aws_db_instance.production.address
    allowed_hosts           = var.allowed_hosts
  }
}

data "template_file" "nginx-app" {
  template = file("templates/nginx_app.json.tpl")

  vars = {
    docker_image_url_nginx  = var.docker_image_url_nginx
    region                  = var.region
    rds_hostname            = aws_db_instance.production.address
    allowed_hosts           = var.allowed_hosts
    
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "saleor-app"
  container_definitions = data.template_file.app.rendered
  depends_on            = [aws_db_instance.production]

  volume {
    name      = "static_volume"
    host_path = "/app/static/"
  }
}

resource "aws_ecs_task_definition" "nginx-app" {
  family                = "nginx-saleor-app"
  container_definitions = data.template_file.nginx-app.rendered
  # depends_on            = [aws_db_instance.production]

  # volume {
  #   name      = "static_volume"
  #   host_path = "/app/static/"
  # }
}

resource "aws_ecs_service" "production" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-api-listener, aws_iam_role_policy.ecs-service-role-policy]

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "saleor-app"
    container_port   = 8000
  }

}

resource "aws_ecs_service" "nginx-production" {
  name            = "${var.ecs_cluster_name}-nginx-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.nginx-app.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-http-listener, aws_iam_role_policy.ecs-service-role-policy]

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx-target-group.arn
    container_name   = "nginx-saleor-app"
    container_port   = 80
  }
  
}