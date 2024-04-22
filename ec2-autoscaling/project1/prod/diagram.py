from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2Ami, EC2, AutoScaling
from diagrams.aws.network import ELB
from diagrams.aws.management import Cloudwatch
from diagrams.aws.database import RDSInstance
from diagrams.aws.security import KeyManagementService, IdentityAndAccessManagementIam, IdentityAndAccessManagementIamRole
from diagrams.aws.security import IAMPermissions
from diagrams.aws.storage import ElasticBlockStoreEBS, ElasticBlockStoreEBSVolume
from diagrams.aws.network import VPC, PrivateSubnet
from diagrams.custom import Custom

with Diagram("Auto Scaling Architecture with Enhanced Organization", show=False):
    
    with Cluster("Launch Template Setup"):
        with Cluster("Volume Services"):
            kms = KeyManagementService("KMS")
            ebs = ElasticBlockStoreEBS("EBS")
            ebs_volume = ElasticBlockStoreEBSVolume("EBS Volume")
            ebs >> kms  # EBS uses KMS for encryption
            ebs >> ebs_volume  # Relation between EBS and EBS Volumes

        with Cluster("IAM Services"):
            iam = IdentityAndAccessManagementIam("IAM")
            iam_role = IdentityAndAccessManagementIamRole("IAMRole")
            iam_policy = IAMPermissions("IAM Policy")
            iam >> iam_role
            iam_role >> iam_policy  # Flow from IAM Role to IAM Policy
            iam_policy >> kms  # IAM Policy allows interaction with KMS

        with Cluster("Network Configuration"):
            vpc = VPC("VPC")
            private_subnet = PrivateSubnet("Private Subnet")
            security_group = Custom("Security Group", "./icons/security_group.png")
            vpc >> private_subnet  # Connect VPC to Private Subnet
            vpc >> security_group  # Connection from VPC to Security Group

        launch_template = Custom("Launch Template", "./icons/launch_template.png")
        ami = EC2Ami("AMI")
        instance_type = EC2("Instance Type")
        key_pair = Custom("Key Pair", "./icons/key_pair.png")
        bootstrap_script = Custom("Bootstrap Script", "./icons/script.png")

        ami >> launch_template
        instance_type >> launch_template
        key_pair >> launch_template
        bootstrap_script >> launch_template
        security_group >> launch_template
        iam_role >> launch_template
        ebs_volume >> launch_template
        private_subnet >> launch_template

    with Cluster("Auto Scaling Setup"):
        with Cluster("Load Balancer Setup"):
            elb = ELB("ELB")
        
        with Cluster("EC2 Instances"):
            ec2_group = [EC2("Instance 1"), EC2("Instance 2")]
            asg = AutoScaling("ASG")
            elb >> asg >> ec2_group
            launch_template >> asg  # Connection from Launch Template to ASG

        with Cluster("Scaling Policies"):
            scale_out = Custom("Scale Out", "./icons/up.png")
            scale_in = Custom("Scale Down", "./icons/down.png")
            asg >> scale_out
            asg >> scale_in

        with Cluster("Monitoring"):
            cw = Cloudwatch("CloudWatch")
            asg >> cw

    with Cluster("Database Layer"):
        with Cluster("RDS Multi-AZ Setup"):
            rds_primary = RDSInstance("RDS Primary")
            rds_secondary = RDSInstance("RDS Secondary")
            rds_primary - rds_secondary  # Representing failover capability

        ec2_group >> rds_primary  # EC2 instances connect to RDS Primary for database operations

# Save the diagram as a PNG file
