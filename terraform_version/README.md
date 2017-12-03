# Example usage of terraform_version module

Tag commit with the correct version of the module as described below:
```
git tag -a terraform_version-0.10.7 -m "Terraform version 0.10.7"
git push origin terraform_version-0.10.7
```

```
module "terraform_version" {
  source = "git::ssh://git@github.com/mtaracha/terraform_modules.git//modules/terraform_version?ref=terraform_version-0.10.7"
}
```
