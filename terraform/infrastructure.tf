# Создание сети
resource "yandex_vpc_network" "my_vpc" {
  name = var.VPC_name
}

# Создание подсетей
resource "yandex_vpc_subnet" "public_subnet" {
  count = length(var.public_subnet_zones)
  name  = "${var.public_subnet_name}-${var.public_subnet_zones[count.index]}"
  v4_cidr_blocks = [
    cidrsubnet(var.public_v4_cidr_blocks[0], 4, count.index)
  ]
  zone       = var.public_subnet_zones[count.index]
  network_id = yandex_vpc_network.my_vpc.id
}

# Для передачи метаданных
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username       = var.username
    ssh_public_key = file(var.ssh_public_key)
    packages       = jsonencode(var.packages)
  }

}

# Мастер нода
resource "yandex_compute_instance" "master-node" {
  name            = var.master_name
  platform_id     = var.platform
  zone            = var.public_subnet_zones[0]
  resources {
    cores         = var.master_core
    memory        = var.master_memory
    core_fraction = var.master_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.master_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet[0].id
    nat       = var.nat
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_serial_port_enable
  }
}

# Воркер нода
resource "yandex_compute_instance" "worker" {
  count           = var.worker_count
  name            = "worker-node-${count.index + 1}"
  platform_id     = var.worker_platform
  zone = var.public_subnet_zones[count.index]
  resources {
    cores         = var.worker_cores
    memory        = var.worker_memory
    core_fraction = var.worker_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.worker_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet[count.index].id
    nat       = var.nat
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_serial_port_enable
  }
}