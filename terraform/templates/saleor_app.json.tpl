[
  {
    "name": "saleor-app",
    "image": "${docker_image_url_django}",
    "essential": true,
    "cpu": 1,
    "memory": 512,
    "links": [],
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "command": ["gunicorn", "-w", "3", "-b", "0.0.0.0:8000", "saleor.wsgi:application"],
    "environment": [
      {
        "name": "RDS_DB_NAME",
        "value": "${rds_db_name}"
      },
      {
        "name": "RDS_USERNAME",
        "value": "${rds_username}"
      },
      {
        "name": "RDS_PASSWORD",
        "value": "${rds_password}"
      },
      {
        "name": "RDS_HOSTNAME",
        "value": "${rds_hostname}"
      },
      {
        "name": "RDS_PORT",
        "value": "5432"
      },
      {
        "name": "ALLOWED_HOSTS",
        "value": "${allowed_hosts}"
      },
      {
        "name": "ALLOWED_CLIENT_HOSTS",
        "value": "*"
      }
    ],
    "mountPoints": [
      {
        "containerPath": "/app/static/",
        "sourceVolume": "static_volume"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/saleor-app",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "saleor-app-log-stream"
      }
    }
  }
]
