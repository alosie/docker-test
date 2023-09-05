# Base image version.
FROM ubuntu:latest

# Terraform version.
ENV DEBIAN_FRONTEND=noninteractive
ARG TERRAFORM_VERSION=1.5.5

# Set labels.
LABEL BaseImage="ubuntu:latest"
LABEL TerraformVersion=${TERRAFORM_VERSION}

# Update the base packages + add a non-sudo user.
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# Install the packages and dependencies along with jq so we can parse JSON.
RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-pip python3-dev awscli openssh-client

# Add Hashicorp Repos and install Terraform.
RUN wget --progress=dot:giga https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Copy across the terraform script.
COPY folder/ .

# Make the script executable.
RUN chmod 777 terraform-script.sh

# Expose port.
EXPOSE 8080

# Set the entrypoint to the terraform script.
ENTRYPOINT ["./terraform-script.sh"]