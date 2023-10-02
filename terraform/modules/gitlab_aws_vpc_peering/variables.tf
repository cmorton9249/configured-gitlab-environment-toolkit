variable "mode" {
  description = "Whether this is the requester or the accepter end of the VPC peering request."
  type        = string
  nullable    = false

  validation {
    condition     = var.mode == "requester" || var.mode == "accepter"
    error_message = "Mode must be either requester or accepter."
  }
}

variable "vpc_id" {
  description = "The ID of the requester VPC."
  type        = string
  nullable    = false
}

variable "route_table_ids" {
  description = "The IDs of the routing table into which a route will be added."
  type        = list(string)
  nullable    = false
}

variable "peer_connection_id" {
  description = "ID for the peering connection made between each VPC. Required for mode=accepter."
  type        = string
  default     = null
}

variable "peer_vpc_id" {
  description = "VPC ID for the VPC network to create a peering connection with. Required for mode=requester."
  type        = string
  default     = null
}

variable "peer_region" {
  description = "AWS region for the VPC network to create a peering connection with. Required for mode=requester."
  type        = string
  default     = null
}

variable "peer_vpc_cidr" {
  description = "CIDR for the VPC network to create a peering connection with."
  type        = string
  nullable    = false
}
