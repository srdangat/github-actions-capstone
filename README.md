 

   # DevSecOps CI/CD Pipeline Pipeline with GitHub Actions 

## 📌 Project Overview

This repository demonstrates a **DevSecOps CI/CD pipeline** for a **Node.js Express** application. It focuses on the "Shift-Left" security, ensuring that security and quality checks are integrated deep into the automated workflow.

The application serves a simple `/health` endpoint, while the infrastructure provides a robust pipeline that automates everything from unit testing to security-hardened container deployments.

---

<p align="center">
  <a href="https://github.com/srdangat/github-actions-capstone/actions/workflows/main-pipeline.yml">
    <img src="https://github.com/srdangat/github-actions-capstone/actions/workflows/main-pipeline.yml/badge.svg" alt="Main Pipeline Status">
  </a>
  <a href="https://github.com/srdangat/github-actions-capstone/actions/workflows/pr-pipeline.yml">
    <img src="https://github.com/srdangat/github-actions-capstone/actions/workflows/pr-pipeline.yml/badge.svg" alt="PR Pipeline Status">
  </a>
  <a href="https://github.com/srdangat/github-actions-capstone/actions/workflows/health-check.yml">
    <img src="https://github.com/srdangat/github-actions-capstone/actions/workflows/health-check.yml/badge.svg" alt="Health Check Status">
  </a>
  <a href="https://hub.docker.com/repository/docker/sanketdangat11/node-app">
    <img src="https://img.shields.io/docker/pulls/sanketdangat11/node-app.svg" alt="Node App Pulls">
  </a>
</p>

             
---                    
                    
                    
 # Pipeline Diagram

![image](images/devsecops.png)



---

## 🛠️ Tech Stack

- **Backend**: [Node.js](https://nodejs.org/) (v18+) & [Express](https://expressjs.com/)
- **Containerization**: [Docker](https://www.docker.com/) & Multi-stage builds
- **CI/CD**: [GitHub Actions](https://github.com/features/actions)
- **Security**: [Trivy](https://github.com/aquasecurity/trivy) (Shift-Left Vulnerability Scanning)
- **Testing**: Node.js Test Runner & Smoke Tests

---

## PR Pipeline
   ![image](images/task4.png)


## Main Branch Pipeline

![image](images/task5.png)


## Scheduled Health Check

![image](images/task6.png)


## Dependency Review

![image](images/depsreview.png)


## 🚀 Getting Started

### 1. Running Locally

Ensure you have [Node.js](https://nodejs.org/) installed on your machine.

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Start the application**:
   ```bash
   npm start
   ```

3. **Verify the endpoint**:
   Open `http://localhost:3000/health` in your browser.

---

### 2. Running with Docker

This project uses multi-stage builds and non-root user isolation for security.

1. **Build the image**:
   ```bash
   docker build -t node-app .
   ```

2. **Run the container**:
   ```bash
   docker run -p 3000:3000 node-app
   ```

3. **Check health**:
   ```bash
   curl http://localhost:3000/health
   ```
