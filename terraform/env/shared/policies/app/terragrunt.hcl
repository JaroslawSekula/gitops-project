terraform {
    source = "../../../../modules/security"
}

inputs = {
    permissions = ["ec2:DescribeInstances", "ec2:DescribeTags", "ec2:DescribeRegion"]
    effect = "Allow"
    service = "ec2.amazonaws.com"
}