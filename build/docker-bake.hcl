# https://medium.datadriveninvestor.com/docker-bake-the-modern-multi-stage-build-standard-in-2025-f8b14471a4cf

group "default" {
  targets = ["ubuntu-all"]
}

# change BAKE_XXX environemt variables
variable "BAKE_UBUNTU_VERSION" {
  type    = string
  default = "24.04" # change BAKE_UBUNTU_BASE environment variable.
}

variable "BAKE_UBUNTU_BASE" {
  type    = string
  default = "docker-image://ubuntu:${BAKE_UBUNTU_VERSION}"
}

variable "BAKE_IMAGE_TAG" {
  type    = string
  default = "${BAKE_UBUNTU_VERSION}"
}

variable "BAKE_IMAGE_PREFIX" {
  type    = string
  default = "lazyzeus/"
}

variable "BAKE_IMAGE_POSTFIX" {
  type    = string
  default = ":${BAKE_IMAGE_TAG}"
}

target "systemd" {
  dockerfile = "systemd.dockerfile"
  context = "./builder"
  contexts = {
    ubuntu-systemd-base = "${BAKE_UBUNTU_BASE}"
  }
  tags = ["${BAKE_IMAGE_PREFIX}ubuntu-systemd${BAKE_IMAGE_POSTFIX}"]
}

target "dockerd" {
  dockerfile = "dockerd.dockerfile"
  context = "./builder"
  depends-on = ["systemd"]
  contexts = {
    ubuntu-dockerd-base = "target:systemd"
  }
  tags = ["${BAKE_IMAGE_PREFIX}ubuntu-dockerd${BAKE_IMAGE_POSTFIX}"]
}

target "gobuilder" {
  dockerfile = "gobuilder.dockerfile"
  context = "./builder"
  contexts = {
    ubuntu-gobuilder-base = "${BAKE_UBUNTU_BASE}"
  }
  tags = ["${BAKE_IMAGE_PREFIX}ubuntu-gobuilder${BAKE_IMAGE_POSTFIX}"]
}

target "vscode" {
  dockerfile = "vscode.dockerfile"
  context = "./builder"
  contexts = {
    ubuntu-vscode-base = "${BAKE_UBUNTU_BASE}"
  }
  tags = ["${BAKE_IMAGE_PREFIX}ubuntu-vscode${BAKE_IMAGE_POSTFIX}"]
}

target "modernunix" {
  dockerfile = "modernunix.dockerfile"
  context = "./builder"
  contexts = {
    ubuntu-modernunix-base = "${BAKE_UBUNTU_BASE}"
  }
  tags = ["${BAKE_IMAGE_PREFIX}ubuntu-modernunix${BAKE_IMAGE_POSTFIX}"]
}

target "ubuntu-all" {
  dockerfile = "all.dockerfile"
  context = "./builder"
  depends-on = [
    "systemd", 
    "dockerd", 
    "gobuilder", 
    "vscode", 
    "modernunix"
  ]
  contexts = {
    ubuntu-all-base = "target:dockerd"
    ubuntu-gobuilder = "target:gobuilder"
    ubuntu-vscode = "target:vscode"
    ubuntu-modernunix = "target:modernunix"
  }
  tags = ["${BAKE_IMAGE_PREFIX}ubuntu-all${BAKE_IMAGE_POSTFIX}"]
}
