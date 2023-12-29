# Base image version.
FROM ubuntu:20.04

# Terraform version.
ARG DEBIAN_FRONTEND=noninteractive
ARG TERRAFORM_VERSION=1.5.5

# Set labels.
LABEL com.yourcompany.BaseImage="ubuntu:20.04" \
      com.yourcompany.TerraformVersion=${TERRAFORM_VERSION}

# Install packages and cleanup in one layer to reduce image size.
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-pip python3-dev awscli openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -u 1001 -U docker

# Add Hashicorp Repos and install Terraform.
RUN wget --progress=dot:giga https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Copy across the terraform script.
COPY scripts/ .

# Switch to a non-root user.
USER docker

# Expose port.
EXPOSE 8080

# Set the default command to run the terraform script.
CMD ["terraform-script.sh"]
