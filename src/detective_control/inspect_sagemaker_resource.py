import boto3
import logging
import traceback

logger = logging.getLogger()
logger.setLevel(logging.INFO)


client = boto3.client('sagemaker')

def stop_training_job(trainingName):
   try:
      response = client.stop_training_job (
         TrainingJobName=trainingName
      )
      logger.info("Stopping training job: " + str(trainingName))
   except Exception:
      traceback.print_exc()
   
def delete_model(modelName):
   try:
      response = client.delete_model(
          ModelName=modelName
      )
      logger.info("Deleting Model: " + str(modelName))
   except Exception:
      traceback.print_exc()


def lambda_handler(event, context):
   logger.info("Event: " + str(event))
   eventName = event['detail']['eventName']
   requestParameters = event["detail"]["requestParameters"]
   
   if eventName == "CreateTrainingJob":
      if "vpcConfig" not in requestParameters:
         stop_training_job(requestParameters["trainingJobName"])
   elif eventName == "CreateModel":
      if "vpcConfig" not in requestParameters:
         delete_model(requestParameters["modelName"])