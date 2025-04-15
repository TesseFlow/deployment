terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}
