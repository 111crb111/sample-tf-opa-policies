package terraform

import input.tfplan as tfplan


required_tags = ["owner", "department"]


contains(arr, elem) {
  arr[_] = elem
}

get_tags(resource) = labels {
    "google" == resource.provider_name
    labels := resource.change.after.labels
} else = tags {
    tags := resource.change.after.tags
} else = empty {
    empty := {}
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    action := resource.change.actions[count(resource.change.actions) - 1]
    contains(["create", "update"], action)
    tags := get_tags(resource)
    existing_tags := [ key | tags[key] ]
    required_tag := required_tags[_]
    not contains(existing_tags, required_tag)

    reason := sprintf(
        "%s: missing required tag %q",
        [resource.address, required_tag]
    )
}
