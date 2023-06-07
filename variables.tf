variable region {
    type = string
}

variable key_name {
    type = string
}

variable instance_type {
    type = string
    default = "t3.micro"
}

variable ami {
    type = string
}

variable instance_name {
    type = string
}

variable environment {
    type = string
}

variable force_destroy {
    default = true
}
