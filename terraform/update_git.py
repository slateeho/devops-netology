#!/usr/bin/env python3
import os
import sys
import boto3
from github import Github

REPO_DIR = "/home/a/netology/modules/Git/devops-netology"
HW_ROOT = os.path.join(REPO_DIR, "HW")

def get_ssm_param(name):
    ssm = boto3.client('ssm', region_name='eu-north-1')
    response = ssm.get_parameter(Name=name, WithDecryption=True)
    return response['Parameter']['Value']

def update_git_repo(hw_dir):
    repo_path = os.path.join(HW_ROOT, hw_dir)
    if not os.path.exists(repo_path):
        print(f"Directory {repo_path} does not exist!")
        return

    # Use PyGithub for authentication
    gh_token = get_ssm_param('GH_TOKEN')
    g = Github(gh_token)
    repo = g.get_repo("slateeho/devops-netology")
    
    # Get current README content
    readme_file = repo.get_contents("README.md")
    current_content = readme_file.decoded_content.decode()
    
    # Add link
    link_text = f"- [HW/{hw_dir}](HW/{hw_dir}/README.md)\n"
    updated_content = current_content + link_text
    
    # Update README via GitHub API with GPG signing
    repo.update_file(
        path="README.md",
        message=f"Добавлена {hw_dir}",
        content=updated_content,
        sha=readme_file.sha,
        committer={"name": "slateeho", "email": "lisogoralexander76@gmail.com"}
    )
    print(f"Added {hw_dir} to README with GPG signing!")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 update_git.py <hw_directory_name>")
        sys.exit(1)
    
    update_git_repo(sys.argv[1])
