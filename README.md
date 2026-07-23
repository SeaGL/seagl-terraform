# SeaGL Cloud Infrastructure

The bulf of SeaGL Cloud is graciously hosted at Oregon State University's Open Source Lab ([OSUOSL][osuosl]), with
some peripheral components hosted elsewhere (for now). The [seagl.org][web] website is currently hosted
on GitHub pages, pending a better alternative. DNS records for seagl.org are currently in AWS.

The OSUOSL exposes [several services][osuosl-serv] to tenants, SeaGL makes use of the [OpenStack][openstack] endpoint.
Resources across all three hosting locations are managed via [Terraform][terraform].

# Contributing

First, a cursory understanding of Terraform is required. Nothing more than an introductory tutorial is required.
Terraform reads all the `*.tf` files in the root of the repository, along with any files referenced from them, to build
a plan for how it will create/update/delete resources. Subdirectories define reusable modules and are only read when
referenced. For example, the `simple_vm` module defines the basis for a virtual machine on OSUOSL's OpenStack. It is
instantiated several times, once for each of the VMs in the SeaGL cloud.

To bootstrap a development environment, install the Terraform CLI and the AWS CLI. To test DNS changes, a personal
AWS account will be required (AWS is only used for DNS, which is a nearly zero cost service). To test VM changes,
any compatible OpenStack cluster is required. Credentials for both will need to be made available in your shell
environment for Terraform to use.

```
# OSUOSL OpenStack Credentials, or run `get-creds.sh` 
export OS_USERNAME=
export OS_PASSWORD=

# AWS Credentials, or utilize AWS CLI profiles, AWS IAM Roles Anywhere, Identity Federation, etc
export AWS_DEFAULT_REGION=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
# Confirm it is working
aws sts get-caller-identity
```

Some resources are globally namespaced, such as AWS S3 buckets, so for personal development the names must
be changed. The list of known resources to update are below (try to keep this up to date):

| File path      | Provider  | Resource Type | Resource Id   | Production Value  |
|----------------|-----------|---------------|---------------|-------------------|
| `s3.tf`        | AWS       | S3 Bucket     | n/a           | `seagl-terraform` |
| `terraform.tf` | Terraform | Backend       | n/a           | `seagl-terraform` |
| `main.tf`      | Terraform | Variable      | zone_name     | `seagl.org`       |
| `main.tf`      | Terraform | Variable      | github_domain | `seagl.github.io` |

There's also a circular dependency which necessitates that the S3 bucket be created by hand:

```
aws s3api create-bucket \
  --bucket seagl-terraform \
  --create-bucket-configuration LocationConstraint=us-west-2
```


Then, run `terraform init` in the root directory to download Terraform extensions for OpenStack and AWS. To test a
change to only one resource, use the `-target` parameter as show below to filter changes to just the resource(s)
under development. For example, to see the outstanding changes to only the `attend.seagl.org` DNS record:

```
# Check reality against the configuration files, filtered to just DNS changes
terraform plan \
  -target aws_route53_record.attend-cname \
  -out targeted.plan 
# Rectify reality by following the planned changes
terraform apply targeted.plan
```

To update the entire DNS infrastructure, multiple `-target` args can be assembled like this:

```
terraform plan 2>/dev/null \
  | grep -Po '(?<= )[^ ]+(?= will be)' \
  | grep route53 \
  | sed -re "s/.+/-target '\\0' \\\\/"
```

**Integration with Test SeaGL Website**

Follow the instructions in the [SeaGL website repo][web-repo] to fork a copy of the SeaGL
website. Adjust the `github_domain` (and optionally `zone_name` if you have a spare domain
lying around to test with) in `main.tf` to match your fork (and your test domain).

[openstack]: https://www.openstack.org/
[osuosl]: https://osuosl.org/
[osuosl-serv]: https://osuosl.org/services/hosting/details/
[terraform]: https://developer.hashicorp.com/terraform
[web]: https://seagl.org
[web-repo]: https://github.com/SeaGL/seagl.github.io#forkclone-the-repository
