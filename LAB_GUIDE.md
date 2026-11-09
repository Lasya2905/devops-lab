# DevOps Lab Guide (Experiments 1-9 + Kubernetes)

SETUP (once, Ubuntu or WSL2 Ubuntu): `bash scripts/install-ubuntu.sh`
Then logout/login so the docker group applies. Test: `docker run hello-world`
Windows without WSL: install Git, Docker Desktop, Jenkins .msi separately; same commands work in Git Bash.

Project files: app.py, test_app.py, requirements.txt, Dockerfile, Jenkinsfile, .gitlab-ci.yml, k8s/, puppet/

---------------------------------------------------------------
## EXPERIMENT 1: DevOps principles, practices, engineer role
AIM: To understand DevOps principles, practices and the DevOps Engineer role and responsibilities.

DESCRIPTION:
DevOps = Development + Operations. A culture and set of practices that automates and integrates software build, test, release and operations for faster, reliable delivery.
Principles: Collaboration, Automation, Continuous Integration/Delivery, Continuous Monitoring, Feedback, Infrastructure as Code.
Practices: Version control, CI/CD, IaC (Puppet/Terraform), Containerization (Docker), Orchestration (Kubernetes), Monitoring (Nagios/Prometheus), Automated testing.
Lifecycle: Plan > Code > Build > Test > Release > Deploy > Operate > Monitor (loop).
DevOps Engineer role: build and maintain CI/CD pipelines, automate infra, manage containers and cloud, configure monitoring, manage source control and releases, troubleshoot prod, bridge dev and ops teams.
Tools: Git, Jenkins, Docker, Kubernetes, Puppet/Ansible, Maven, Selenium, Nagios.

CODE: none.
RESULT: Principles, practices and role of a DevOps engineer were studied.
EXAM: Draw the infinity-loop lifecycle diagram, write the tool for each stage.

---------------------------------------------------------------
## EXPERIMENT 2: Version Control System tools
AIM: To explore Version Control System tools for Source Code Management.

DESCRIPTION:
VCS tracks changes to files over time, supports collaboration, branching, rollback.
Types: Local (RCS), Centralized (SVN, CVS, Perforce: single central server), Distributed (Git, Mercurial: every user has full copy).
Git: fast, distributed, branching is cheap. GitHub/GitLab/Bitbucket host Git repos and add pull requests, issues, CI.
Git areas: Working directory > Staging area > Local repo > Remote repo.

CODE: `git --version`
RESULT: VCS types and tools (Git, SVN, Mercurial) were explored; Git was chosen for distributed SCM.
EXAM: Show comparison table Centralized vs Distributed.

---------------------------------------------------------------
## EXPERIMENT 3: Install Git, GitHub account, Git operations
AIM: To install Git, create a GitHub account and execute various Git operations.

STEPS:
1. Install: `sudo apt install git -y` (Windows: git-scm.com)
2. Create account at github.com, create empty repo `devops-lab` (no README).
3. In the project folder run (replace email; for push use a Personal Access Token as password: GitHub > Settings > Developer settings > Tokens):
```
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
git clone https://github.com/Lasya2905/devops-lab.git test-clone
git pull
git diff
git reset --hard HEAD~1   (undo last commit, optional)
```
RESULT: Git installed, repo pushed to GitHub, branching, merging, cloning and logs executed.
EXAM: Show GitHub repo page in browser + `git log --oneline` output.

---------------------------------------------------------------
## EXPERIMENT 4: Install and configure Jenkins, build job (CI)
AIM: To install and configure Jenkins and set up a build job to understand Continuous Integration.

DESCRIPTION: Jenkins is an open-source automation server (Java) that builds, tests and deploys code automatically on each commit.

STEPS:
1. Install (done by scripts/install-ubuntu.sh) or:
   `docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins:lts`
2. Open http://localhost:8080
3. Password: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
   (docker: `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`)
4. Install suggested plugins > create admin user.
5. Freestyle job: New Item > name `build-job` > Freestyle project > OK.
   - Source Code Management: Git > URL https://github.com/Lasya2905/devops-lab.git > branch */main
   - Build Triggers: Poll SCM `* * * * *`
   - Build Steps > Execute shell:
```
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt
pytest -v
```
   - Save > Build Now > click build number > Console Output.
6. Pipeline job (better marks): New Item > Pipeline > Pipeline script from SCM > Git > Script Path `Jenkinsfile` > Build Now. Stage View shows each stage.
RESULT: Jenkins installed; build job fetched code from GitHub, ran tests; Console Output shows "Finished: SUCCESS".
EXAM: Show dashboard green ball, Console Output, then push a small change and show auto-triggered build.

---------------------------------------------------------------
## EXPERIMENT 5: Jenkins Master-Slave architecture
AIM: To understand Jenkins Master-Slave architecture and scale the standalone setup by adding slave nodes.

DESCRIPTION: Master schedules jobs, manages config and UI. Agents (slaves) execute builds. Distributes load and allows different OS/environments.

STEPS (agent on same laptop is fine):
1. Manage Jenkins > Nodes > New Node > name `agent1` > Permanent Agent.
2. Remote root directory: `/home/<user>/jenkins-agent` (mkdir it). Labels: `agent1`. Usage: only build jobs with matching label. Launch method: Launch agent by connecting it to the controller.
3. Save. Open the node page; it shows the command with secret. In a new terminal:
```
mkdir -p ~/jenkins-agent && cd ~/jenkins-agent
curl -sO http://localhost:8080/jnlpJars/agent.jar
java -jar agent.jar -url http://localhost:8080/ -secret <SECRET> -name agent1 -webSocket -workDir ~/jenkins-agent
```
   (If webSocket fails: Manage Jenkins > Security > Agents: set TCP port Fixed 50000, remove -webSocket.)
4. Node shows online. Edit job > tick "Restrict where this project can be run" > label `agent1` > Build Now.
5. Console Output shows: "Running on agent1".
RESULT: Slave node connected; job executed on agent1 instead of the built-in node.
EXAM: Show Nodes page (both nodes), and Console Output line "Running on agent1".

---------------------------------------------------------------
## EXPERIMENT 6: Docker architecture, container life cycle, commands
AIM: To understand Docker architecture and container life cycle, install Docker, and execute commands to manage images and containers.

DESCRIPTION: Architecture: Docker Client > Docker Daemon (dockerd) > Images / Containers / Networks / Volumes; Registry (Docker Hub) stores images.
Container life cycle: Created > Running > Paused > Stopped > Deleted.

STEPS:
```
sudo apt install docker.io -y
docker --version
docker info
docker pull nginx
docker images
docker run -d --name web -p 8081:80 nginx        (open http://localhost:8081)
docker ps
docker ps -a
docker logs web
docker exec -it web bash          (exit to leave)
docker pause web
docker unpause web
docker stop web
docker start web
docker restart web
docker rm -f web
docker rmi nginx
docker network ls
docker volume create myvol
docker system prune -f
```
RESULT: Docker installed; images pulled; containers created, started, stopped and removed.
EXAM: Show nginx welcome page in browser + `docker ps`.

---------------------------------------------------------------
## EXPERIMENT 7: Dockerfile, build image for sample web app
AIM: To learn Dockerfile instructions and build an image for a sample web application.

DESCRIPTION: Dockerfile instructions: FROM (base), WORKDIR, COPY/ADD, RUN (build time), CMD/ENTRYPOINT (run time), EXPOSE, ENV, VOLUME.

FILES: app.py, requirements.txt, Dockerfile (provided).
COMMANDS:
```
docker build -t devops-lab:1.0 .
docker images
docker run -d --name devops-lab -p 5000:5000 devops-lab:1.0
curl http://localhost:5000          (or open in browser)
curl http://localhost:5000/health
docker logs devops-lab
docker stop devops-lab && docker rm devops-lab
```
Optional push to Docker Hub: `docker login`, `docker tag devops-lab:1.0 <hubuser>/devops-lab:1.0`, `docker push <hubuser>/devops-lab:1.0`
RESULT: Image built from Dockerfile; container served the web app at port 5000.
EXAM: Explain each Dockerfile line; show browser output.

---------------------------------------------------------------
## EXPERIMENT 8: Puppet install and configure (pull-based SCM)
AIM: To install and configure pull-based Software Configuration Management and provisioning tool Puppet.

DESCRIPTION: Puppet is pull-based IaC: Agent nodes periodically (every 30 min) pull their catalog from Puppet Master (server), apply it and report. Config is written in declarative manifests (.pp). Default port 8140.

STEPS A: Standalone (works on one laptop, use this in exam)
```
wget https://apt.puppet.com/puppet8-release-jammy.deb
sudo dpkg -i puppet8-release-jammy.deb
sudo apt update
sudo apt install puppet-agent -y
echo 'export PATH=$PATH:/opt/puppetlabs/bin' >> ~/.bashrc && source ~/.bashrc
puppet --version
sudo puppet apply puppet/examples/hello.pp
cat /tmp/hello_puppet.txt
```
(Ubuntu 24.04: use `puppet8-release-noble.deb`. Quick alternative: `sudo apt install puppet`.)

STEPS B: Master-Agent (pull), explain/show if asked
```
# master
sudo apt install puppetserver -y
sudo systemctl enable --now puppetserver
# agent  (edit /etc/puppetlabs/puppet/puppet.conf)
[main]
server = <master-hostname>
# add master IP to /etc/hosts on both
sudo /opt/puppetlabs/bin/puppet agent -t          (agent sends cert request)
sudo /opt/puppetlabs/bin/puppetserver ca list     (on master)
sudo /opt/puppetlabs/bin/puppetserver ca sign --all
sudo /opt/puppetlabs/bin/puppet agent -t          (agent pulls catalog)
```
RESULT: Puppet installed; manifest applied and file created at /tmp/hello_puppet.txt; notify message printed.
EXAM: Show `puppet --version`, apply output (Notice lines), cat of the file.

---------------------------------------------------------------
## EXPERIMENT 9: Puppet blocks (Manifest, Modules, Classes, Functions)
AIM: To learn SCM and provisioning using Puppet blocks: manifest, modules, classes, functions.

DESCRIPTION:
Manifest: .pp file with resources. Resource: file, package, service, user, exec.
Class: named reusable block of resources. Defined type: class-like block with multiple instances.
Module: directory structure (manifests/, files/, templates/, functions/) packaging classes.
Function: built-in (upcase, join, notice) or custom (function webapp::greet).

COMMANDS:
```
# classes + defined type + functions
sudo /opt/puppetlabs/bin/puppet apply puppet/examples/class_example.pp
cat /tmp/greeting.txt /tmp/demo1.txt

# module (installs nginx, writes page, starts service)
sudo /opt/puppetlabs/bin/puppet apply --modulepath=puppet/modules -e "include webapp"
curl http://localhost
systemctl status nginx

# syntax check and dry run
puppet parser validate puppet/examples/class_example.pp
sudo puppet apply --noop puppet/examples/hello.pp
```
Run `puppet apply` a second time: output shows no changes (idempotency).
RESULT: Classes, defined types, a module and functions were created and applied; nginx page showed "Hello, DevOps Student - served by Puppet".
EXAM: Explain module folder tree: webapp/manifests/init.pp, webapp/functions/greet.pp.

---------------------------------------------------------------
## KUBERNETES (if asked)
AIM: To deploy the containerized app on Kubernetes and expose it with a Service.
DESCRIPTION: Kubernetes orchestrates containers. Master: API server, etcd, scheduler, controller manager. Worker: kubelet, kube-proxy, container runtime. Objects: Pod, Deployment, Service, ReplicaSet.

STEPS (minikube):
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo snap install kubectl --classic
minikube start --driver=docker
docker build -t devops-lab:1.0 .
minikube image load devops-lab:1.0
kubectl apply -f k8s/
kubectl get pods
kubectl get deployments
kubectl get svc
minikube service devops-lab-svc --url        (open URL in browser)
kubectl scale deployment devops-lab --replicas=4
kubectl get pods
kubectl delete pod <one-pod-name>            (a new one is auto-created: self healing)
kubectl describe pod <pod-name>
kubectl delete -f k8s/
```
RESULT: App deployed with 2 replicas, exposed via NodePort; scaling and self-healing demonstrated.

---------------------------------------------------------------
## GitLab CI (.gitlab-ci.yml)
Push repo to GitLab: `git remote add gitlab https://gitlab.com/<user>/devops-lab.git && git push gitlab main`
Pipeline appears at Build > Pipelines (stages: test, build). Shared runners must be enabled (Settings > CI/CD > Runners).

---------------------------------------------------------------
## HOW TO PRESENT IN THE EXAM
1. Before the exam: run everything once tonight, fix errors, keep Jenkins and Docker started.
2. Keep 3 terminal tabs: project folder, Puppet, kubectl. Browser tabs: GitHub repo, Jenkins (8080), app (5000).
3. For each experiment: say the AIM in one line, run the commands, show output, say the RESULT line.
4. Order of demo: Git push > Jenkins job build > agent node > docker build/run > puppet apply > module > (k8s).
5. Take screenshots of each output (Console Output, docker ps, browser pages, puppet apply) as backup in case of lab network/install failure.
6. If install fails in lab: use Docker for Jenkins (`docker run jenkins/jenkins:lts`) and `puppet apply` standalone.
7. Common viva Qs: What is CI vs CD? Master-slave purpose? Image vs container? CMD vs RUN? Pull vs push CM? What is idempotency? Pod vs Deployment?
