# Software Development Process and Requirements Engineering in RSE

The software development process typically consists of several central phases, which collectively guide the creation, implementation, and maintenance of software systems. These phases help ensure a systematic and organized approach to building software. 

Here is a brief introduction to the central phases of the software development process:

The Software Development Life Cycle (SDLC) is a structured process for planning, creating, testing, and deploying software. Here's a breakdown of the key phases, incorporating your requested points:

1. Planning and Requirements Gathering:

This initial phase is crucial for understanding and documenting the needs and expectations of all stakeholders, including clients, end-users, and other relevant parties. The goal is to define the software's functionality, features, and constraints in detail. This ensures the final product meets everyone's expectations.

2. Analysis:

Following requirements gathering, a thorough analysis takes place. This involves dissecting the collected information to identify the system's functionalities, user types, data needs, and potential interactions. This analysis lays the groundwork for the design phase.

3. Design:

With a clear understanding of the requirements, the system design phase begins.  Here, the overall architecture and structure of the software are planned. This includes high-level design decisions like choosing the technology stack, defining data structures, and outlining the software's components and modules.

4. Implementation:

This is where the development team translates the design specifications into functional code. Developers follow coding standards, best practices, and use the chosen programming languages to create the software.

5. Testing and Integration:

The software undergoes rigorous testing to ensure it meets the specified requirements and functions correctly. Various testing methods are employed, such as unit testing (individual components), integration testing (how components work together), and system testing (overall functionality). This phase identifies and fixes defects, guaranteeing the software's reliability.

6. Maintenance:

Once the software is deployed to a production environment for actual use, the work isn't over.  The maintenance phase involves addressing issues, bugs, and updates.  This includes providing support, troubleshooting problems, and releasing updates or patches to improve the software based on user feedback and evolving requirements.


<!--
TODO CREATE NEW IMAGE
```{figure} ../figures/app_classes/software_dev_phases.png
:name: Software_dev_cycle
Software Development Process
```



1. Requirements Gathering:

This phase involves understanding and documenting the needs and expectations of stakeholders, including clients, end-users, and other relevant parties.
The goal is to define the functionality, features, and constraints that the software must satisfy.

2. System Design:

In this phase, the overall architecture and structure of the software are planned. It includes high-level design decisions, such as choosing the appropriate technology stack, defining data structures, and outlining the software's components and modules.

3. Implementation:

This is the phase where the actual code is written based on the design specifications.
Developers follow coding standards, best practices, and use the chosen programming languages to translate the design into executable code.

4. Testing:

The testing phase involves verifying that the software meets the specified requirements and functions correctly.
Various testing methods, such as unit testing, integration testing, and system testing, are employed to identify and fix defects and ensure the software's reliability.

5. Deployment and Maintenance & support:

Once the software has passed testing and quality assurance, it is deployed to a production environment for actual use.
This phase involves setting up the necessary infrastructure, configuring servers, and making the software accessible to end-users.

After deployment, ongoing maintenance is required to address issues, bugs, and updates. This phase involves providing support, troubleshooting, and releasing updates or patches to improve or enhance the software based on user feedback and changing requirements.

-->
### Documentation

Throughout the entire software development process, documentation is crucial. It includes requirements documents, design documents, and user manuals to provide clear guidelines for understanding, using, and maintaining the software.
### Iterative Processes:

Many software development methodologies, such as Agile or DevOps, involve iterative processes where the development cycle is repeated, allowing for continuous improvement and adaptation to changing requirements.
These phases collectively form a structured framework for developing reliable, maintainable, and scalable software systems. The specific details of each phase may vary based on the development methodology being employed and the nature of the project.

## Requirements Engineering in RSE

Approaching research projects necessitates a flexible and iterative method, acknowledging the exploratory and evolving nature of such endeavors.

Developers must consistently collaborate with stakeholders to adapt to changes, ensuring the software aligns with research objectives. Descriptions and specifications outline what the software should achieve and its expected behavior, encompassing needs, functionalities, constraints, and quality attributes. These serve as a groundwork for software design, development, and validation, offering guidance throughout the entire software engineering lifecycle.

**User requirements** concentrate on user needs and expectations, fostering a user-centric approach that aids in comprehending the system's context and goals. For instance: "Users should have the ability to post updates, photos, and videos."

On the other hand, **system requirements** furnish technical specifications for construction, adopting a developer-centric standpoint to steer implementation. Functional requirements delineate desired software behavior, such as "The system should enable users to create new accounts" or "The system should present summarized figures in a dashboard."

**Non-functional requirements** delineate additional qualities or characteristics sought in the software system, like response time ("The system should respond within 2 seconds") or compatibility with web browsers ("The system should be compatible with all major web browsers").

### Recommended approach:

1. Understand the Research Context: Gain a deep understanding of the research domain, objectives, and constraints. Collaborate closely with the researchers to grasp the scientific goals and the problem being addressed.

2. Stakeholder Identification: Identify the stakeholders involved in the research project. This typically includes researchers, domain experts, funding agencies, end-users, and potentially software developers.

3. Elicitation Techniques: Employ appropriate elicitation techniques to capture requirements. These techniques may include interviews, workshops, surveys, and observations. Researchers and domain experts should be actively involved in this process to ensure the accuracy and relevance of requirements.

4. Prioritize Requirements: Research projects often have time and resource constraints. Collaborate with stakeholders to prioritize requirements based on their importance and potential impact on the research outcomes. Consider factors such as scientific significance, feasibility, and project timelines.

5. Document Requirements: Document the requirements in a clear and concise manner. Use a combination of natural language, diagrams, and mockups to communicate requirements effectively. Ensure that the documentation is accessible and understandable.

6. Iterative Refinement: Recognize that research projects are dynamic and subject to change. Embrace an iterative approach to requirements engineering, allow for continuous refinement and adaptation. Regularly review and update requirements based on new insights, research findings, and evolving stakeholder needs.

7. Traceability and Versioning: Establish traceability between requirements and the research outcomes. This helps to ensure that the developed software meets the intended objectives. Maintain version control for the requirements documentation to track changes and facilitate collaboration.

8. Collaboration and Communication: Foster open and frequent communication channels among stakeholders, including researchers, software developers, and end-users. Encourage feedback and collaboration throughout the research software development process to ensure alignment with evolving research needs.

9. Validation and Verification: Establish mechanisms for validating and verifying the implemented software against the requirements. This can involve rigorous testing, peer reviews, and involving domain experts to assess the alignment of the software with the research objectives.

### Documenting Requirements:

Being flexible in documentation entails the ability to tailor the documentation forms to the unique needs of the project, ensuring accessibility, comprehensibility, and adaptability. It involves a recognition that different projects may require different approaches to convey information effectively.

Consideration of various documentation forms is crucial to achieving this flexibility:

- **Natural Language**:

Description: Utilizing natural language involves expressing project information in a narrative, conversational manner.

Advantages: Readable and accessible to a diverse audience, accommodating different levels of technical expertise.

Adaptability: Allows for detailed explanations and provides a comprehensive overview of project elements.

- **Diagrams**:

Description: Visual representations such as flowcharts, UML diagrams, or data flow diagrams.
Advantages: Offers a visual understanding of complex relationships or processes.
Adaptability: Useful for conveying system architecture, data flow, and interactions between components.

- **Mockups and Prototypes**:

Description: Visual representations or interactive models showcasing the intended look and feel of the software.

Advantages: Allows stakeholders to visualize the end product early in the development process.

Adaptability: Particularly useful for eliciting feedback on the design and user interface.

```{figure} ../figures/app_classes/mock_up.png
:name: mock_up
Web Desing example mock up
```
_(image can be found [here](https://www.appcues.com/blog/ui-mockups-and-tools))_

- **Use Cases:**

Description: Use cases are a technique employed to capture the interactions and behaviors between actors (users or external systems) and a system. They provide a detailed account of how the system will be used in various scenarios.

Advantages: Enables a comprehensive understanding of user-system interactions, facilitating the identification of functional requirements.

Adaptability: Ideal for describing functional requirements by illustrating the steps and actions necessary to accomplish a specific goal or task within the system.

Example: In a research software application, a specific use case might be "Generate Report" with the following main flow:

**Use Case: Generate Report**

Primary Actor: Researcher
Main Flow:

1. The researcher selects the "Generate Report" option in the research software.
2. The system prompts the researcher to choose the desired report format (e.g., PDF, Excel).
3. . The researcher selects the report format.
4. . The system processes the available research data.
5. The system generates the report in the selected format.
6. The researcher receives the generated report.

This specific use case illustrates the step-by-step process of how a researcher interacts with the system to generate a report, showcasing the practical application of use cases in describing system functionality.

- **User Stories:**

Description: User stories are concise, user-centric narratives following the template "As a [user role], I want [action/features] so that [benefit/reason]." They focus on expressing end-users' needs, providing a tangible understanding of their goals and the value the features bring.

Advantages: Offers a direct connection to user needs, promoting a user-centric approach to development.

Adaptability: Particularly effective for agile development, enabling clear communication of user requirements and expectations.

**_Example User Story:_**

User Story: "As a researcher, I want to generate a report in PDF or Excel format, so that I can easily share and analyze the research findings."

By incorporating user stories into the documentation, the project team ensures that the development process aligns closely with the needs and expectations of the end-users, fostering a more user-centered and value-driven approach.

## MoSCoW Prioritization

MoSCoW prioritization is a widely utilized technique in project management and software development to prioritize user stories or other requirements based on their importance and urgency. The acronym stands for:

- **Must have**: Denotes essential, critical, and core functionality that is imperative for the project's success. These are features without which the project cannot proceed.

- **Should have**: Represents valuable and important features that are not critical for the project's immediate success. While desirable, these functionalities can be deferred to subsequent phases if necessary.

- **Could have**: Encompasses features that are considered nice to have but are not necessary for the project's essential functionality. These can be considered as potential enhancements but are not critical for the current scope.
- **Won't have**: Indicates features that are of the lowest priority or currently out of scope. These are functionalities that are acknowledged but intentionally deferred for the moment.

### Benefits of MoSCoW Prioritization:

MoSCoW Prioritization offers several advantages in project management:

- **Informed Decision-Making**: By categorizing requirements into distinct priority levels, teams can make informed decisions about where to focus their efforts, ensuring that critical aspects are addressed first.

- **Incremental Development**: The prioritization scheme supports incremental development by emphasizing the importance of delivering essential functionality first. This allows for iterative releases and continuous improvement.

- **Resource Optimization**: MoSCoW helps optimize resource allocation by directing attention to must-have and should-have features first. This prevents unnecessary investment in less critical functionalities.

- **Clear Communication**: The classification of requirements into must-have, should-have, could-have, and won't-have provides a clear and shared understanding among team members and stakeholders about the project's priorities.

By systematically organizing requirements into priority levels, teams can ensure that they address critical needs while allowing flexibility for future enhancements. This approach fosters an iterative and adaptive development process.


## UML Diagrams

Unified Modeling Language (UML) is a standardized visual modeling language widely used in software development to represent, document, and communicate system architectures and designs. UML diagrams serve as powerful tools for various stages of the software development lifecycle. You can find a more detailed discription [here](https://www.visual-paradigm.com/tutorials/). 

An example UML-diagram {cite:p}`williams2016statistical`:

```{figure} ../figures/app_classes/uml_diagram.png
:name: UML
Taxonomy of UML diagramming notations.. PLOS ONE. Figure.
```

When it comes to capturing and analyzing requirements, several key UML diagrams play a crucial role:

- **Use Case Diagrams**:

*Purpose: Use case diagrams provide a high-level view of the system's functionality from the end-users' perspective.*

*Content: They depict actors, representing external entities, and use cases, representing specific functionalities or features of the system.*

*Benefit for Requirements: Use case diagrams help identify and clarify user requirements by illustrating the interactions between users and the system, highlighting the main functionalities required.*

- **Activity Diagrams:**

*Purpose: Activity diagrams model the flow of activities within a system, illustrating how different tasks are performed and how they relate to each other.*

*Content: Nodes represent activities, and transitions depict the flow of control between them.*

*Benefit for Requirements: Activity diagrams are useful for understanding the dynamic aspects of a system, helping to refine and elaborate on requirements by visualizing the sequence of actions and decision points.*

UML Activity Diagrams are used to represent the conceptual workflow steps of a functionality, without specifying concrete tools or implementations. 
These diagrams include activity nodes for each step and edges that illustrate the order of execution, dependencies, and conditional branchings. 
Additional information, such as data, can also be incorporated. 
They serve as a foundation for implementation in a workflow management system, like Snakemake. 
Additionally, a plain text list of non-functional requirements should be considered in the process.

```{figure} ../figures/app_classes/uml_workflow.png
:name: UML_WORKFLOW
.UML Workflow  Activity Diagramm [https://academic.oup.com/nar/article/40/7/2846/1187540](https://academic.oup.com/nar/article/40/7/2846/1187540)
```

And here you have an description on the connections between activities:

```{figure} ../figures/app_classes/uml_meaning.png
:name: UML_meaning
Activity Diagram - Building Blocks - from [https://www.drawio.com/blog/uml-activity-diagrams](https://www.drawio.com/blog/uml-activity-diagrams)
```


- **Class Diagrams:**

*Purpose: Class diagrams provide a static view of the system, depicting the structure and relationships among classes.*

*Content: Classes, attributes, and associations between classes are represented in class diagrams.*

*Benefit for Requirements: Class diagrams help in understanding the data and object-oriented aspects of the system, facilitating the identification and organization of key entities and their relationships.*

- **State Machine Diagrams:**

*Purpose: State machine diagrams model the behavior of a system in response to external stimuli, illustrating the different states a system can be in and the transitions between them.*

*Content: States, transitions, and events are key elements in state machine diagrams.*

*Benefit for Requirements: State machine diagrams assist in capturing and refining the requirements related to the dynamic behavior of the system, particularly when the system's response depends on its current state.*

- **Sequence Diagrams:**

*Purpose: Sequence diagrams focus on the interactions between objects over time, illustrating the order of messages exchanged between them.*

*Content: Objects, lifelines, and messages are fundamental components of sequence diagrams.*

*Benefit for Requirements: Sequence diagrams help in understanding the flow of communication and collaboration between different components of the system, aiding in the refinement and validation of requirements related to system interactions.*


## Where to put this in the repo?


There are multiple approaches to this, no single solution fits all. Typical approaches use either **README file, Documentation folder, Wiki pages**, and **Issue Tracking**  or a combination of them to manage and organize information within a project. Each approach has its own advantages and is suitable for different scenarios. Let's elaborate on each:

- **README File:**

Purpose: A README file is typically placed in the root directory of a project and serves as a quick introduction and guide for users and contributors.

Content: It often includes essential information such as project overview, installation instructions, usage guidelines, and basic troubleshooting tips.

Advantages: Simple and easy to create and maintain. It's especially useful for small to medium-sized projects where a concise guide is sufficient.

- **Documentation Folder:**

Purpose: A Documentation folder is more extensive than a README file and contains comprehensive documentation about the project.

Content: This may include user guides, developer guides, API documentation, and other detailed information related to the project.

Advantages: Suitable for larger projects with multiple components or extensive features. It provides a structured way to organize information and is more detailed than a README.

- **Wiki Pages:**

Purpose: Wikis are collaborative spaces where team members can collectively create, edit, and organize content.

Content: Wiki pages can cover a wide range of topics, including project history, design decisions, team guidelines, and more.

Advantages: Enables collaborative documentation, making it suitable for teams that prefer to distribute the responsibility of maintaining and updating documentation. Useful for projects with evolving and dynamic information.

- **Issue Tracking:**

Purpose: Issue tracking systems (e.g., GitHub Issues, Jira) are primarily used for managing tasks, bugs, and feature requests.
Content: Each issue can have its own discussion, attachments, and labels, making it a central hub for communication related to specific tasks or problems.
Advantages: While not a traditional documentation method, issue tracking is crucial for managing project tasks. It helps in tracking progress, discussing specific issues, and maintaining a record of changes over time.
Choosing an Approach:


Consider the size and complexity of your project. For smaller projects, a well-structured README might be sufficient. Larger projects may benefit from a combination of approaches.

Assess your team's preferences and collaboration style. If your team is accustomed to working collaboratively, a Wiki or shared Documentation folder might be suitable.

Understand the needs of your users and contributors. If your project has a user base that requires detailed documentation, investing in a comprehensive Documentation folder or Wiki could be essential.

Ultimately, the choice of approach should align with your team's culture, project requirements, and collaboration dynamics. Combining multiple approaches is also a valid strategy, as long as it enhances overall project understanding and contributes to a positive collaborative environment.
