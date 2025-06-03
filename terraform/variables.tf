# Базовые переменные
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

# Переменные для сети
variable "VPC_name" {
  type        = string
  default     = "my-vpc"
}

# Переменные для подсетей
variable "public_subnet_name" {
  type        = string
  default     = "public"
}

variable "public_v4_cidr_blocks" {
  type        = list(string)
  default     = ["192.168.1.0/24"]
}

variable "subnet_zone" {
  type        = string
  default     = "ru-central1"
}

variable "public_subnet_zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b",  "ru-central1-d"]
}

# Переменные для мастер ноды
variable "master_name" {
  type        = string
  default     = "control-plane"
}

variable "platform" {
  type        = string
  default     = "standard-v1"
}

variable "master_core" {
  type        = number
  default     = "4"
}

variable "master_memory" {
  type        = number
  default     = "8"
}

variable "master_core_fraction" {
  description = "guaranteed vCPU, for yandex cloud - 20, 50 or 100 "
  type        = number
  default     = "20"
}

variable "master_disk_size" {
  type        = number
  default     = "50"
}

variable "scheduling_policy" {
  type        = bool
  default     = "true"
}

# Переменные для воркер нод
variable "worker_count" {
  type        = number
  default     = "2"
}

variable "worker_platform" {
  type        = string
  default     = "standard-v1"
}

variable "worker_cores" {
  type        = number
  default     = "4"
}

variable "worker_memory" {
  type        = number
  default     = "2"
}

variable "worker_core_fraction" {
  description = "guaranteed vCPU, for yandex cloud - 20, 50 or 100 "
  type        = number
  default     = "20"
}

variable "worker_disk_size" {
  type        = number
  default     = "50"
}

variable "nat" {
  type        = bool
  default     = "true"
}

# Общие переменные для ВМ
variable "image_id" {
  type        = string
  default     = "fd83imruae299cbehbsb"
}

# Для cloud-init.yml
variable "username" {
  description = "name of predefined user on VM"
  default     = "cloud-alex"
  type        = string
}

variable "ssh_public_key" {
  type        = string
  description = "Location of SSH public key."
  default     = "/home/alex/.ssh/id_ed25519.pub"
}

variable "vm_serial_port_enable" {
  type        = bool
  default     = true
}

variable "packages" {
  type    = list(string)
  default = ["nano", "mc"]
  description = "Packages to install on vm creates"
}
