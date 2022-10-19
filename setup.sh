REGION=us-central1
PROJECT=aible-gcp-containers-beta
US_REPO=demo-multi-region-us
ASIA_REPO=demo-multi-region-asia
# Set Region
gcloud config set run/region $REGION
gcloud config set compute/region $REGION
gcloud config set workflows/location $REGION
# Enable APIs
gcloud services enable compute.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable iamcredentials.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Create New SA for image build and assign required roles
BUILD_SA=aible-build-sa
BUILD_SA_EMAIL="${BUILD_SA}@${PROJECT}.iam.gserviceaccount.com"

gcloud iam service-accounts create $BUILD_SA --display-name "Aible Image Build Service Account" && {
    gcloud projects add-iam-policy-binding $PROJECT --member "serviceAccount:${BUILD_SA_EMAIL}" --role=roles/iam.serviceAccountTokenCreator
    gcloud projects add-iam-policy-binding $PROJECT --member "serviceAccount:${BUILD_SA_EMAIL}" --role=roles/cloudbuild.builds.editor
    gcloud projects add-iam-policy-binding $PROJECT --member "serviceAccount:${BUILD_SA_EMAIL}" --role=roles/logging.logWriter
    gcloud projects add-iam-policy-binding $PROJECT --member "serviceAccount:${BUILD_SA_EMAIL}" --role=roles/iam.serviceAccountUser
    gcloud projects add-iam-policy-binding $PROJECT --member "serviceAccount:${BUILD_SA_EMAIL}" --role=roles/artifactregistry.writer    
    
} || {
    echo Using existing Service Account $BUILD_SA_EMAIL
}

# Create Artifact Repo for US Multiregion
gcloud artifacts repositories create ${US_REPO} \
    --repository-format=docker \
    --location=us \
    --description="Aible service image US Repo" \
    --async \

# Create Artifact Repo for ASIA Multiregion
gcloud artifacts repositories create ${ASIA_REPO} \
    --repository-format=docker \
    --location=asia \
    --description="Aible service image Asia repo" \
    --async \

# Create cloudbuild trigger
gcloud beta builds triggers create github \
    --repo-name=cloud-run-deploy \
    --repo-owner=Andy7047 \
    --tag-pattern=.* \
    --build-config=cloudbuild.yaml \
    --service-account=projects/$PROJECT/serviceAccounts/${BUILD_SA_EMAIL} \
    --include-logs-with-status