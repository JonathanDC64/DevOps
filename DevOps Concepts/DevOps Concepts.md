# DevOps Concepts

- [DevOps Concepts](#devops-concepts)
  - [DevOps engineer](#devops-engineer)
  - [Traditional software development](#traditional-software-development)
  - [DevOps team (culture)](#devops-team-culture)
  - [Traditional work environment (Waterfall Model)](#traditional-work-environment-waterfall-model)
  - [Agile work environment (Agile Model)](#agile-work-environment-agile-model)
  - [How DevOps Fits in](#how-devops-fits-in)

## DevOps engineer

> Knowledge on infrastructure and also how to code, test, track and monitor applications.

DevOps is used by companies and organizations to boost their productivity and evolve rapidly.

Adopting DevOps will enable you to deliver specific types of products and services at
a much higher speed than when using the conventional software development path.

## Traditional software development

There are 2 teams:

- Development team responsible for coding and testing the application
- Operations team receives application from dev team once it is complete

The Operations team provisions the necessary infrastructure to release the application,
deploy and perform several maintenance tasks like monitoring.

Problems with this approach:

- Wall between both teams (Each teams does their own work in isolation)

- If there are bugs in a deployed application, the dev team won't know until it's too late

- Blame is redirected between teams (QA blames Dev, Dev blames Operations, etc..)

There may be a Quality Assurance team (QA), but again, they are in isolation from the other teams.

## DevOps team (culture)

All teams work together in a more collaborative environment.
Some of the tasks that are usually done by the Operations team is now also done
by the Development team.

Benefits:

- Major decrease in time spent in:

  - Software building and deployment

  - Application maintenance and bug fixing

  - Releasing new features and versions of the application.

## Traditional work environment (Waterfall Model)

Each phase is built on each other.

Phases:

- Requirements
  - Where all the information is gathered
  - Why the application will be build
  - What problems it solves
  - What features it has
  - Documentation and planing

- Design
  - Where results of Requirements phase are used to plan the application design
  - Assessing software and hardware requirements

- Implementation
  - Coding of the application starts
  - Does not start until both requirements and design phases are over
  - Software is coded in separate units (usually called modules)
  - Unit testing

- Verification (Integration)
  - Software units developed in previous phase are integrated to form the application
  - Integration testing

- Maintenance
  - After deployment, issues arise that need to be fixed
  - Also after deployment, the need may arise for new features in the app
  - Any new feature needs to go through every step of the waterfall model

Drawbacks of this model:

- No working copy of the software is available until late in the process (Partially available in Verification phase, fully available in Maintenance phase)
- Once a phase is complete, it is not so simple to go back to a previous phase to add new info
- Bugs are spotted late in the software development life cycle

## Agile work environment (Agile Model)

Software development is divided into multiple iterations.

Each iteration has the following phases:

1. Planing: Only plan for whats needed in the current iteration
2. Analysis: Also limited to current iteration requirements
3. Designing: Where developers start designing and coding the application. (Produces working application that is missing a lot of features)
4. Building: Compilation and Unit testing of the application
5. Testing: Integration testing and Quality Assurance
6. Return to Planing phase for next iteration...

Advantages of this methodologies:

- Each iteration usually takes no more than 2 weeks
- Customer is engaged in the process at each step (Receives a working version of the product (incomplete) and Reviews current state of the project, gives feedback)
- Changes are naturally adopted at any stage of the project, just add them to the next iteration

## How DevOps Fits in

DevOps helps organizations achieve the benefits of Agile development methodologies by shifting
the workflow paradigm towards faster development phases.

The following are the main stages of a project developed with DevOps principles in mind:

- Continuous integration: Code is integrated into the body of the application as soon as it is saved.
- Continuous delivery: Builds upon continuous integration, includes running further automated tests before merging code from the integration branch with the main branch. Usually helps make code ready to be deployed
- Continuous deployment: Code is deployed into a production environment ina fully automated manor.

---

How to do it?

The strongest aspect of DevOps is the adoption of automation whenever possible.
Automation boosts speed and lowers the error margin.

In order to automate a task, you need a tool.
DevOps tasks include planing, coding, building, testing, releasing, deploying, operating
and monitoring.

DevOps tools form an ecosystem, where the output of each tool becomes the input of the next one.

The advent of virtualization and - following it - the rise of cloud computing helped ease
the process even more.
Whole sets of tools, or even a complete infrastructure can be built on the cloud using
providers like Amazon AWS, Google Cloud among others.

Virtualization refers to to abstracting the hardware resources on the machine so that  a
single server can run several machines at the same time.
This yields massive decrease in the total cost of running a similar infrastructure
using traditional physical hardware.

---

DevOps Tools:

|| Tools |
|-|-|
| Virtualization                                                             | VirtualBox, VMWare, Vagrant |
| Containerization                                                           | Docker      |
| Continuous integration, continuous delivery, continuous deployment (CI/CD) | Jenkins |
| Configuration management                                                   | Ansible, Chef, Puppet |
| Version Control                                                            | Git |
