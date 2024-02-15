# Application Classes

The German Aerospace Center (DLR) {cite:p}`schlauch2018dlr` has established a framework for classifying software applications based on their criticality and associated risks. 

The Application Classes (AC) play a crucial role in defining suitable measures for software quality. They enable the customization of activities and tools according to specific needs while organizing stakeholder communication related to software quality.

These classes provide recommendations that build on each other to ensure proper engineering practices and software quality. Their primary objectives include safeguarding investment, reducing risks, and retaining knowledge. The measures implemented should align with the requirements of the respective application class.

The primary focus of application classes is to support the development of individual software within facilities. Moreover, they can serve as a foundation for establishing requirements when outsourcing software development to external companies, ensuring the quality of development. This is particularly valuable when externally created software is intended for future maintenance or further development by the facility.

```{figure} ../figure/app_class/app_class.pnd
:name: app_class
Application Classes 0 - 3
```

## Application Class 0

This class concentrates on software intended for personal use within a limited scope, without plans for distribution within or outside the DLR. Software falling into this category often emerges in the context of specific research problems, with the respective facility determining the necessary measures, such as adhering to good scientific practices. 

Examples of application class 0 include scripts for data processing related to publications, basic administrative scripts for task automation, and software developed solely for demonstrating specific functions or testing purposes.


## Application Class 1

Software in this class should be usable by individuals not involved in its development, with the potential for ongoing development. This serves as the foundational level for software intended for broader use beyond personal purposes. To achieve this, the current version must be traceable and reproducible, showcasing essential requirements, constraints, functional scope, and known issues.

Application class 1 is recommended when the software has a narrower functional scope or when the facility develops it within specific limitations. Examples include software developed by students during studies, bachelor or master theses, software resulting from dissertations with no long-term development focus, and software from third-party projects emphasizing demonstration without planned long-term development.

## Application Class 2 

Class 2 Is designed to ensure the enduring development and maintainability of software in this category, serving as a foundation for transitioning to product status. Structured management of specific requirements is crucial, with a focus on addressing constraints and quality requirements through an appropriate software architecture. This involves defining technical concepts and software structure, preserving development know-how, and enabling an evaluation of suitability for new usage scenarios. A defined development process, design and implementation rules, along with the incorporation of test automation, are essential. 

This class is recommended for software with extensive functionality developed for the long term, such as those resulting from dissertations emphasizing maintainability and long-term usage, third-party projects with similar concerns beyond the project's scope, and large research frameworks lacking product characteristics.

## Application Class 3 
In contrast, class 3 emphasizes the imperative of error avoidance and risk reduction, particularly for critical software with product characteristics. Active risk management is integral, involving the identification and mitigation of technical solution risks within the software architecture. Expanding test automation and implementing structured reviews are essential to detect errors early and ideally prevent them in the production version. Ensuring traceability of changes is also emphasized.

This class is recommended for software development associated with high risks, including those related to product liability, certification, external requirements, or the software's significance for value-adding activities. 

Examples include mission-critical software in aircraft, autonomous vehicles, or space missions, software with warranties from the facility (internally or externally), and software making substantial contributions to third-party funding and research results, necessitating reliable performance.
