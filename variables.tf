# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "max_images_retained" {
  description = "The max number of images to keep in the repository before expiring the oldest"
  type        = number
  default     = 100
}

variable "max_protected_images_retained" {
  description = "The max number of images retained per protected image tag to keep in the repository before expiring the oldest"
  type        = number
  default     = 1
}

variable "max_untagged_images_retained" {
  description = "The max number of untagged images to keep in the repository before expiring the oldest"
  type        = number
  default     = 1
}

variable "protected_image_tag_prefixes" {
  description = "A list of image tag prefixes that should be given extra protection against having their images expired"
  type        = list(string)
  default     = []
}

variable "trusted_accounts" {
  description = "IDs of other accounts that are trusted to pull and push to this repostitory"
  type        = list(any)
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(any)
  default     = {}
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = bool
  default     = true
}

variable "enable_scan_on_push" {
  description = "Enable vulnarability scanning on image push"
  type        = bool
  default     = true
}

variable "extra_ecr_policies" {
  description = "Extra policy documents in JSON to use for the ECR repository"
  type        = list(string)
  default     = []
}
