# Packer - Consul

![circleci build status](https://circleci.com/gh/daveshepherd/packer-consul.png?style=shield "circleci build status")

Builds AWS AMI images for [consul](https://www.consul.io/) using [Packer](https://www.packer.io/) based on the official
Ubuntu AMI image in the eu-west-1 and eu-west-2 regions.

This is unconfigured, to configure it place the
[consul configuration file](https://www.consul.io/docs/agent/options.html) into `/etc/consul.d`, you may choose to do
this as [user data in an autoscaling group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html).

This image is private and is based off a private Ubuntu image which is also built with Packer. The base Ubuntu image
is built to include configuration and components required across all servers, which makes it unsuitable for public
consumption. However, feel free to use this as an example of how to do build consul AMIs.

The reason for this is for implementing the idea of immutable infrastructure, where updates and upgrade a baked into the
AMI and the updated version is deployed to replace the existing servers. In the case of Consul, this is done as a
rolling update, where a new server is brought into service, checked that it has joined the cluster successfully, then an
old one is terminated. This is repeated until all servers in the cluster is running the latest AMI. 

## Configuration

The following environment variables are required to build this image

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY	
* VPC_ID - The ID of a VPC to use for the build, e.g. vpc-abcd1234
* SUBNET_ID - The ID of the subnet to use for the build, e.g. subnet-efgh5678
* DESTINATION_REGIONS - A list of regions to replicate this AMI to, e.g. eu-west-2,us-west-1

## AWS IAM policy

The AWS access key id and secret access key should have the following permissions, for each region:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "NonResourceLevelPermissions",
            "Action": [
                "ec2:Describe*",
                "ec2:CreateVolume",
                "ec2:CreateKeypair",
                "ec2:DeleteKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateImage",
                "ec2:CopyImage",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:RegisterImage",
                "ec2:CreateTags",
                "ec2:ModifyImageAttribute",
                "ec2:RequestSpotInstances",
                "ec2:CancelSpotInstanceRequests"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "AllowInstanceActions",
            "Effect": "Allow",
            "Action": [
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:DeleteVolume"
            ],
            "Resource": [
                "arn:aws:ec2:eu-west-1:123456789012:instance/*",
                "arn:aws:ec2:eu-west-1:123456789012:volume/*",
                "arn:aws:ec2:eu-west-1:123456789012:security-group/*"
            ],
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Name": "Packer Builder"
                }
            }
        },
        {
            "Sid": "EC2RunInstancesSubnet",
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances"
            ],
            "Resource": [
                "arn:aws:ec2:eu-west-1::image/*",
                "arn:aws:ec2:eu-west-1:123456789012:key-pair/*",
                "arn:aws:ec2:eu-west-1:123456789012:network-interface/*",
                "arn:aws:ec2:eu-west-1:123456789012:security-group/*",
                "arn:aws:ec2:eu-west-1:123456789012:volume/*",
                "arn:aws:ec2:eu-west-1:123456789012:instance/*",
                "arn:aws:ec2:eu-west-1:123456789012:subnet/subnet-efgh5678",
                "arn:aws:ec2:eu-west-1:123456789012:vpc/vpc-*"
            ]
        },
        {
            "Sid": "SGVPCDelete",
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteSecurityGroup"
            ],
            "Resource": [
                "*"
            ],
            "Condition": {
                "StringEquals": {
                    "ec2:vpc": [
                        "arn:aws:ec2:eu-west-1:123456789012:vpc/vpc-abcd1234"
                    ]
                }
            }
        }
    ]
}
```