from pprint import pprint
from botocore.exceptions import ClientError
import boto3

print("Welcome to the aws service manager!\nPlease choose one of the following options:\n1 - Manage S3 Buckets\n2 - Manage EC2 Instances\n3 - Exit\n")
try:
    uc = int(input())
except Exception:
    raise

if uc == 1:
    print("S3 Manager")
    print("Please choose one of the following options:\n1 - List Buckets\n2 - Create Bucket\n3 - Delete Bucket\n4 - exit")
    try:
        uc = int(input())
    except Exception:
        raise
    if uc == 1:
        print("List Buckets")
        s3_client = boto3.client("s3")
        res = s3_client.list_buckets()
        for bucket in res["Buckets"]:
            print(bucket['Name'])
    elif uc == 2:
        print("Create Bucket")
        uc = input("Please specify the name of the S3 bucket you want to create: ")
        s3_client = boto3.client("s3")
        res = s3_client.create_bucket(Bucket=uc)
        pprint(res)
    elif uc == 3:
        print("Delete Bucket")
        uc = input("Please specify the name of the S3 bucket you want to delete: ")
        s3_client = boto3.client("s3")
        res = s3_client.delete_bucket(Bucket=uc)
        pprint(res)
    else:
        print("Bye Bye!")
        exit()
elif uc == 2:
    print("EC2 Manager")
    print("Please choose one of the following options:\n1 - List Instances\n2 - Start Instance\n3 - Stop Instance\n4 - Terminate Instance\n5 - exit")
    try:
        uc = int(input())
    except Exception:
        raise
    if uc == 1:
        print("List Instances")
        ec2_client = boto3.client("ec2")
        res = ec2_client.describe_instances()
        pprint(res)
    elif uc == 2:
        print("Start Instance")
        uc = input("Please specify the instance_id of the EC2 instance to start: ")
        ec2_client = boto3.client("ec2")
        try:
            res = ec2_client.start_instances(InstanceIds=[uc],DryRun=True)
            pprint(res)
        except ClientError as e:
            print("Invalid ID")
    elif uc == 3:
        print("Stop Instance")
        uc = input("Please specify the instance_id of the EC2 instance to stop: ")
        ec2_client = boto3.client("ec2")
        try:
            res = ec2_client.stop_instances(InstanceIds=[uc],DryRun=True)
            pprint(res)
        except ClientError as e:
            print("Invalid ID")
    elif uc == 4:
        print("Terminate Instance")
        uc = input("Please specify the instance_id of the EC2 instance to terminate: ")
        ec2_client = boto3.client("ec2")
        try:
            res = ec2_client.terminate_instances(InstanceIds=[uc],DryRun=True)
            pprint(res)
        except ClientError as e:
            print("Invalid ID")
    else:
        print("Bye Bye!")
        exit()
elif uc == 3:
    print("Bye Bye!")