# Openleaf custom changes

# AWS/EC2 environment variables
export INSTANCEID="$(ec2metadata --instance-id)"
export LOCALIP="$(ec2metadata --local-ipv4)"
export PUBLICIP="$(ec2metadata --public-ipv4)"
export DNSHOSTNAME="$(ec2metadata --instance-id).aws"
export HOSTLOCATION="AWS/$(ec2metadata --availability-zone)"