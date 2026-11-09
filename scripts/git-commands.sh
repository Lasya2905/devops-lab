#!/bin/bash
# Experiment 3: run line by line in the exam, not as one script
git config --global user.name "Lasya Poonati"
git config --global user.email "YOUR_EMAIL"
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/Lasya2905/devops-lab.git
git push -u origin main
git checkout -b feature1
echo "# change" >> README.md
git add . && git commit -m "feature1 change"
git checkout main
git merge feature1
git log --oneline
git status
