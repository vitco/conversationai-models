#!/bin/bash

#
# A script to train the kaggle model remotely using ml-engine.
#
# Setup Steps:
# 1. Install the gcloud SDK
# 2. Authenticate with the GCP project you want to use, `gcloud config set project [my-project]`
# 3. Put the train and test data in Cloud Storage, `gsutil cp [DATA_FILE] gs://[BUCKET_NAME]/`
#

# Edit these!
BUCKET_NAME=kaggle-model-experiments
JOB_NAME=test_kaggle_training
REGION=us-central1

DATE=`date '+%Y%m%d_%H%M%S'`
OUTPUT_PATH=gs://${BUCKET_NAME}/${USER}-${DATE}

echo "Writing to $OUTPUT_PATH"

# Remote
gcloud ml-engine jobs submit training ${JOB_NAME}_${DATE} \
    --job-dir $OUTPUT_PATH \
    --runtime-version 1.4 \
    --module-name trainer.model \
    --package-path trainer/ \
    --region $REGION \
    --verbosity debug \
    -- \
    --train_data gs://${BUCKET_NAME}/train.csv \
    --y_class toxic \
    --train_steps 1500 \
    --saved_model_dir gs://${BUCKET_NAME}/saved_models/${USER} \
    --model_dir gs://${BUCKET_NAME}/model/${USER}/${DATE} \
    --model cnn \


echo "You can view the tensorboard for this job with the command:"
echo ""
echo -e "\t tensorboard --logdir=gs://${BUCKET_NAME}/model/${USER}/${DATE}"
echo ""
echo "And on your browser navigate to:"
echo ""
echo -e "\t http://localhost:6006/#scalars"
echo ""
echo "This will populate after a model checkpoint is saved."
echo ""
