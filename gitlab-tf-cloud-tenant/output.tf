output "clone_script" {
  value = join("", formatlist("\n  git clone %s", [for p in gitlab_project.project : p.ssh_url_to_repo]))
}

output "group_runners_token" {
  value = gitlab_group.group.runners_token
}

output "group_path" {
  value = local.group_path
}

output "group_id" {
  value = gitlab_group.group.id
}