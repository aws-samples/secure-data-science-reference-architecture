# Let's write some utility functions to do extract model artifacts and generate feature importances for XGBoost Model.
import boto3
import re
import tarfile
import matplotlib.pyplot as plt
import xgboost as xgb
# from sklearn.externals import joblib
import joblib

def download_artifacts(job_name, local_fname):
    ''' Given a trial name in a SageMaker Experiment, extract the model file and download it locally'''
    sm_client = boto3.Session().client('sagemaker')
    response = sm_client.describe_trial_component(TrialComponentName=job_name)
    model_artifacts_full_path = response['OutputArtifacts']['SageMaker.ModelArtifact']['Value']  
    
    p = re.compile('(?<=s3://).*?/')
    s = p.search(model_artifacts_full_path)
    object_name_start = s.span()[1]
    object_name = model_artifacts_full_path[object_name_start:]
    bucket_name = s.group()[:-1]
    s3 = boto3.client('s3')
    s3.download_file(bucket_name, object_name, local_fname)

def unpack_model_file(fn):
    # Unpack model file
    _tar = tarfile.open(fn, 'r:gz')
    _tar.extractall()
    _fil = open('xgboost-model', 'rb')
    _model = joblib.load(_fil)
    print(_model)
    
    return _model

def plot_features(model, columns):
    num_features = len(columns)
    fig, ax = plt.subplots(figsize=(6,6))
    xgb.plot_importance(model, max_num_features=num_features, 
                    height=0.8, ax=ax, show_values = False)
    plt.title('Top Model Feature Importance')
    plt.show()
