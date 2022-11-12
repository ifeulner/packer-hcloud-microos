variable "hcloud_token" {
  type    = string
  default = "${env("HCLOUD_TOKEN")}"
}

source "hcloud" "microos-snapshot" {
  image       = "ubuntu-20.04"
  rescue      = "linux64"
  location    = "nbg1"
  server_type = "cx21" # at least 40GiB disk is needed for MicroOS image
  snapshot_labels = {
    microos-snapshot = "yes"
  }
  snapshot_name = "microos-snapshot"
  ssh_username  = "root"
  token         = "${var.hcloud_token}"
}

build {
  sources = ["source.hcloud.microos-snapshot"]

  # install MicroOS image and reboot
  provisioner "shell" {
    script = "scripts/install_microos.sh"
    expect_disconnect = true
  }

  # Check if connection to MicroOS based instance is possible
  provisioner "shell" {
    inline = [
        "echo Reboot successful.",
        "uname -a"
    ]
  }
}
