terraform {
    source = "../../../../modules/security"
}
dependencies {
    paths = [
        "../../../shared/backend"
    ]
}
include {
  path = "${get_repo_root()}/terraform/env/shared/us-east-1/region.hcl"
}
inputs = {
    permissions = [ "ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath", "ec2:DescribeInstances", "ec2:DescribeTags", "ec2:DescribeRegion"]
    effect = "Allow"
    service = "ec2.amazonaws.com"
}