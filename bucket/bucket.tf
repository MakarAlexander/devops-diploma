# Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name = "sa-for-s3"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

# Создание бакета с использованием ключа
resource "yandex_storage_bucket" "tstate" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "bucket-amakartsev-diplom"
  acl           = "private"
  force_destroy = true

}
# Конфигурация для бэкэнда terraform к S3 бакета
resource "local_file" "backend" {
  content  = <<EOT
  provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
  token     = var.token
}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "bucket-amakartsev-diplom"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # необходимая опция при описании бэкенда для Terraform версии 1.6.1 и старше.
    skip_s3_checksum            = true # необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
  required_version = ">= 1.6.4"
}
EOT
  filename = "../terraform/providers.tf"
}