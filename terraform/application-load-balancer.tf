# Создание целевой группы для нод кластера
resource "yandex_alb_target_group" "k8s_nodes" {
  name = "k8s-nodes-tg"

  target {
    subnet_id  = yandex_vpc_subnet.public_subnet[0].id
    ip_address = yandex_compute_instance.master-node.network_interface[0].ip_address
  }

  dynamic "target" {
    for_each = yandex_compute_instance.worker
    content {
      subnet_id  = yandex_vpc_subnet.public_subnet[target.key].id
      ip_address = target.value.network_interface[0].ip_address
    }
  }
}

# Создание группы бэкендов
resource "yandex_alb_backend_group" "k8s_backend" {
  name = "k8s-backend-group"

  http_backend {
    name             = "k8s-http-backend"
    weight           = 1
    port             = 30080
    target_group_ids = [yandex_alb_target_group.k8s_nodes.id]
    
    healthcheck {
      timeout  = "10s"
      interval = "2s"
      http_healthcheck {
        path = "/healthz"
      }
    }
  }
}

# Создание HTTP-роутера
resource "yandex_alb_http_router" "k8s_router" {
  name = "k8s-http-router"
}

# Создание виртуального хоста
resource "yandex_alb_virtual_host" "k8s_host" {
  name           = "k8s-virtual-host"
  http_router_id = yandex_alb_http_router.k8s_router.id
  
  route {
    name = "all-traffic"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.k8s_backend.id
        timeout          = "60s"
      }
    }
  }
}

# Создание балансировщика
resource "yandex_alb_load_balancer" "k8s_balancer" {
  name        = "k8s-alb"
  network_id  = yandex_vpc_network.my_vpc.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public_subnet[0].id
    }
  }

  listener {
    name = "k8s-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.k8s_router.id
      }
    }
  }
}
