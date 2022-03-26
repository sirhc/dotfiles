# AWS region selection
function asr() {
    export AWS_DEFAULT_REGION="$1"
}
compdef _aws_regions asr

function _aws_regions() {
    local -a aws_regions
    aws_regions=($(aws ec2 describe-regions --all-regions --region us-east-1 --query 'Regions[*].[RegionName]' --output text))
    _describe -t aws_regions 'aws_regions' aws_regions && return 0
}
