variable "vm_name" {
    description =   "Name of the VM"
    type    =      list(string)
    default =   ["k8s-master", "k8s-worker1"]
}

variable "location" {
    description =   "Region to build the resource"
    default     =   "Southeast Asia"
}