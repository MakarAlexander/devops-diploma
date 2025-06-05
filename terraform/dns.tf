resource "yandex_dns_zone" "amakartsev" {
  name        = "amakartsev"
  description = "Публичная зона для домена amakartsev.ru"
  zone        = "amakartsev.ru."
  public      = true
}

resource "yandex_dns_recordset" "domain" {
  zone_id = yandex_dns_zone.amakartsev.id
  name    = "@"
  type    = "A"
  ttl     = 300
  data    = [yandex_alb_load_balancer.k8s_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "app" {
  zone_id = yandex_dns_zone.amakartsev.id
  name    = "app"
  type    = "A"
  ttl     = 300
  data    = [yandex_alb_load_balancer.k8s_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "grafana" {
  zone_id = yandex_dns_zone.amakartsev.id
  name    = "grafana"
  type    = "A"
  ttl     = 300
  data    = [yandex_alb_load_balancer.k8s_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}