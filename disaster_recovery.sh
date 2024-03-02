#!/bin/bash

# Configuration
source_directories="/etc/ssh"  # Add your source directories here
destination_directory="/home/backup"                 # Specify the destination directory
backup_filename="backup_$(date +'%Y%m%d_%H%M%S').tar.gz" # Define the backup filename
notification_email="sachinsharma75012@gmail.com"             # Specify your email address for notifications
aws_region="ap-south-1"                            # Specify your AWS region
sns_topic_arn="arn:aws:sns:ap-south-1:082459098973:Github-Mail"                      # Specify your SNS topic ARN
github_username="sachinsharma1812"                  # Specify your GitHub username
github_repository="Linux"              # Specify your GitHub repository name

# Create backup directory if it doesn't exist
mkdir -p "$destination_directory"

# Create tar archive of source directories
tar -czvf "${destination_directory}/${backup_filename}" $source_directories

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: ${backup_filename}"

    # Send notification via AWS SNS
    aws sns publish --topic-arn "$sns_topic_arn" --region "$aws_region" --subject "Backup Successful" --message "Backup successful: ${backup_filename}"

    # Push script to GitHub repository
    git add "$0"
    git commit -am "Updated backup script"
    git push "https://${github_username}:${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}@github.com/${github_username}/${github_repository}.git" master
    echo "Script has been pushed to GitHub repository."

else
    echo "Backup failed"

    # Send notification via AWS SNS
    aws sns publish --topic-arn "$sns_topic_arn" --region "$aws_region" --subject "Backup Failed" --message "Backup failed for some reason."
fi
