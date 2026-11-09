# macOS GUIDE (use this instead of the Ubuntu commands in LAB_GUIDE.md)
Aim/Description/Result text in LAB_GUIDE.md stays the same. Only commands change.
Terminal = zsh. Run all from the devops-lab folder.

## 0. One-time setup
    bash scripts/install-mac.sh
    open -a Docker                       # wait until whale icon says "running"
    source ~/.zshrc
    brew services start jenkins-lts

## !! PORT NOTE
macOS uses port 5000 for AirPlay Receiver. Use 5001 on the host: -p 5001:5000
(or System Settings > General > AirDrop & Handoff > turn off AirPlay Receiver)

## Exp 1-2: theory only. `git --version`
## Exp 3: Git
    git --version                         (if missing: xcode-select --install)
    then same commands as scripts/git-commands.sh
    Push password = GitHub Personal Access Token.

## Exp 4: Jenkins
    brew services start jenkins-lts
    open http://localhost:8080
    cat ~/.jenkins/secrets/initialAdminPassword
    (Docker alternative: docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
     password: docker exec <container> cat /var/jenkins_home/secrets/initialAdminPassword)
    Job steps identical (Execute shell: python3 -m venv venv ... pytest -v).
    Pipeline job: Jenkinsfile already sets PATH for brew + Docker.
    Stop later: brew services stop jenkins-lts

## Exp 5: Agent node
    mkdir -p ~/jenkins-agent && cd ~/jenkins-agent
    curl -sO http://localhost:8080/jnlpJars/agent.jar
    $(brew --prefix openjdk@17)/bin/java -jar agent.jar -url http://localhost:8080/ -secret <SECRET> -name agent1 -webSocket -workDir ~/jenkins-agent
    Node remote root dir in Jenkins: /Users/<yourmacusername>/jenkins-agent
    (If Mac asks to allow incoming connections: Allow)

## Exp 6-7: Docker (Docker Desktop must be running)
    Same commands as LAB_GUIDE, but ports:
    docker run -d --name web -p 8081:80 nginx            -> http://localhost:8081
    docker build -t devops-lab:1.0 .
    docker run -d --name devops-lab -p 5001:5000 devops-lab:1.0
    curl http://localhost:5001 ; curl http://localhost:5001/health

## Exp 8: Puppet
    puppet --version
    puppet apply puppet/examples/hello.pp
    cat /tmp/hello_puppet.txt /tmp/puppet_date.txt
    If `puppet` not found:  export PATH="$(brew --prefix ruby)/bin:$PATH"
    Fallback (no Ruby gem): run Puppet in Docker
      docker run --rm -v "$PWD/puppet:/puppet" puppet/puppet-agent apply /puppet/examples/hello.pp

## Exp 9: Puppet blocks
    puppet apply puppet/examples/class_example.pp
    cat /tmp/greeting.txt /tmp/demo1.txt
    puppet apply --modulepath=puppet/modules -e "class { 'webapp': manage_nginx => false, docroot => '/tmp/webapp' }"
    cat /tmp/webapp/index.html
    puppet parser validate puppet/examples/class_example.pp
    puppet apply --noop puppet/examples/hello.pp
    Run apply twice: second run shows no changes (idempotent).
    (Master-agent: explain theory only on Mac, demo with puppet apply.)

## Kubernetes
    minikube start --driver=docker
    docker build -t devops-lab:1.0 .
    minikube image load devops-lab:1.0
    kubectl apply -f k8s/
    kubectl get pods ; kubectl get svc
    minikube service devops-lab-svc --url      (keep terminal open, open URL in browser)
    kubectl scale deployment devops-lab --replicas=4
    kubectl delete pod <pod-name> ; kubectl get pods       (self-healing)
    kubectl delete -f k8s/ ; minikube stop

## Exam-day checklist
- Docker Desktop open, `brew services list` shows jenkins-lts started
- Browser tabs: GitHub repo, localhost:8080, localhost:5001
- Screenshots of each output as backup
