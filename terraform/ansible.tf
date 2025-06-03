# Генерация файла inventory для запуска Kubespray
resource "local_file" "ansible_inventory" {
  depends_on = [
    yandex_compute_instance.master-node,
    yandex_compute_instance.worker
  ]
  
  content = templatefile("../templates/inventory.yml.tftpl", {
    master_name        = yandex_compute_instance.master-node.name
    master_external_ip = yandex_compute_instance.master-node.network_interface[0].nat_ip_address
    workers = [
      for instance in yandex_compute_instance.worker : {
        name        = instance.name
        external_ip = instance.network_interface[0].nat_ip_address
      }
    ]
  })
  
  filename = "./inventory.yml"
}
