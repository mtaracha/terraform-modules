# terraform-modules
As a best practise you should version control your modules by tagging them i.e.
```
git tag -a <service_name>-x.x.x -m "<What has chanaged>"
git push origin <service_name>-x.x.x
```
i.e.
```
git tag -a ecs_service-0.0.1 -m "Creation of ECS service module"
git push origin ecs_service-0.0.1
```
And add source of the module as presented below:
```
  source = "git::ssh://git@github.com:mtaracha/terraform-modules.git//ecs_service?ref=ecs_service-latest"
```
