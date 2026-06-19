### OUTPUTS ###
# output "control-public-ip" {
#     value = google_compute_instance.control.network_interface[0].access_config[0].nat_ip
# }

# output "worker-ips" {
#     value = google_compute_instance.worker[*].network_interface[0].network_ip
# }
output "local-control-ip" {
    value = google_compute_instance.control.network_interface[0].network_ip
}
output "local-worker-ip" {
    value = google_compute_instance.worker[*].network_interface[0].network_ip
}
output "public-control-ip" {
     value = google_compute_instance.control.network_interface[0].access_config[0].nat_ip
}
output "public-worker-ip" {
     value = google_compute_instance.worker[*].network_interface[0].access_config[0].nat_ip
}
