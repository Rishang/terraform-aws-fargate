import boto3

ecs = boto3.client('ecs')

cluster='test-app'
tasks = ecs.list_tasks(
    cluster=cluster,
    serviceName='whoami',
    launchType='FARGATE'
)

tasks_info = ecs.describe_tasks(
    cluster=cluster,
    tasks=tasks["taskArns"]
)

print("displaying running tasks")
for i in tasks_info['tasks']:
    print(f"id: {i['taskArn']} | type: {i['capacityProviderName']}")
