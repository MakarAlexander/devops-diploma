# Network Outputs
output "vpc" {
  value = {
    name = yandex_vpc_network.my_vpc.name
    id   = yandex_vpc_network.my_vpc.id
  }
  description = "VPC network details"
}

output "public_subnets" {
  value = [ 
    for subnet in yandex_vpc_subnet.public_subnet : {
      id         = subnet.id
      name       = subnet.name
      cidr_block = subnet.v4_cidr_blocks[0]
      zone       = subnet.zone
    }
  ]
  description = "Details of all public subnets"
}

# Master Node Outputs
output "master_node" {
  value = {
    name        = yandex_compute_instance.master-node.name
    external_ip = yandex_compute_instance.master-node.network_interface[0].nat_ip_address
    internal_ip = yandex_compute_instance.master-node.network_interface[0].ip_address
  }
  description = "Master node details"
}

# Worker Nodes Outputs
output "worker_nodes" {
  value = [ 
    for worker in yandex_compute_instance.worker : {
      name        = worker.name
      external_ip = worker.network_interface[0].nat_ip_address
      internal_ip = worker.network_interface[0].ip_address
    }
  ]
  description = "Worker nodes details"
}

# Load Balancer Outputs
output "alb_external_ip" {
  value = yandex_alb_load_balancer.k8s_balancer.listener[*].endpoint[*].address[*].external_ipv4_address[*].address
}