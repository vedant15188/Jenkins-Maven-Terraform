data "aws_iam_role" "ecs_role" {
  name = "ecsTaskExecutionRole"
}

# Provision a task definition
resource "aws_ecs_task_definition" "MavenTaskDef" {
  family                   = "MavenTaskDef"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "0.5 vcpu"
  memory                   = "1 gb"
  network_mode             = "awsvpc"
  execution_role_arn       = "${data.aws_iam_role.ecs_role.arn}"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "MavenWebSite",
      "image": "${aws_ecr_repository.ECR.repository_url}:latest",
      "cpu": 1,
      "memory": 128,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ]
    }
  ]
  DEFINITION

}

# Get data for SG for ALB
data "aws_security_group" "lb_sg" {
  name = "Basic-SG"
}

# Provision a cluster
resource "aws_ecs_cluster" "ECS_Cluster" {
  name               = "MavenCluster"
  capacity_providers = ["FARGATE"]
}

# Get Data for default subnet
data "aws_subnet" "public_1a" {
  availability_zone = "ap-south-1a"
  default_for_az    = true
}

data "aws_subnet" "public_1b" {
  availability_zone = "ap-south-1b"
  default_for_az    = true
}

resource "aws_ecs_service" "my_first_service" {
  name            = "my-first-service"                            # Naming our first service
  cluster         = "${aws_ecs_cluster.ECS_Cluster.id}"           # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.MavenTaskDef.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 #  Setting the number of containers we want deployed to 3

  network_configuration {
    security_groups  = ["${data.aws_security_group.lb_sg.id}"]
    subnets          = ["${data.aws_subnet.public_1a.id}", "${data.aws_subnet.public_1b.id}"]
    assign_public_ip = true # Providing our containers with public IPs
  }
}
