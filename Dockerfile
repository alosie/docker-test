# Base image version.
FROM ubuntu:latest

# Terraform version.
ENV DEBIAN_FRONTEND=noninteractive
ARG TERRAFORM_VERSION=1.5.5

# Set labels.
LABEL com.yourcompany.BaseImage="ubuntu:latest"
LABEL com.yourcompany.TerraformVersion=${TERRAFORM_VERSION}

# Install packages and cleanup.
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-pip python3-dev awscli openssh-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -m docker

# Add Hashicorp Repos and install Terraform.
RUN wget --progress=dot:giga https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Revert DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=

# Copy across the terraform script.
COPY folder/ .

# Make the script executable.
RUN chmod 755 terraform-script.sh

# Switch to a non-root user.
USER docker

# Expose port.
EXPOSE 8080

# Set the entrypoint to the terraform script.
ENTRYPOINT ["./terraform-script.sh"]
