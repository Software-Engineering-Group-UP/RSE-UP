# Project Assignment 2: Name, Idea and Basic Setup

The Instructions below contain a fairly comprehensive set of instructions to get you started with the second course project, which you will do in a group. Please take sufficient Bme to go through all the points to make sure you are set up for the next assignments to come. 


In the second course project you will work on a slightly larger challenge, which comes with a need for using additional software engineering techniques. You will work on this project in a team, which has advantages (more working power available), but also new challenges (like communication and coordination of work). This week you should develop your project idea, give the project a name, and do an initial project setup, so that you are good to start with more technical aspects next week. Please follow the instrucBons below to get to that point:


## Project Idea and Name

In the first project we were quite specific regarding the choice of a dataset and what to do with it. In the second project you have more freedom to develop your own project idea. 
Mind that the project does not have to be much larger, and if you like you can do a similar kind of data analysis, that is also fine. In any case, make sure to pay attention to the following points:

    - Your project should be a research software project, so in some sense deal with processing data or performing a simulation in order to answer a research question. 
    - The focus should be on developing a (Python) library for performing the kind of analysis that you have chosen. Think of the DLR’s application class 2 here, i.e. specialized functionality that is meant to be used by others.
    - One person in your team should take the role of a user (“client”) of the library and focus on developing a Jupyter notebook and/or command-line interface that uses the library to demonstrate how it can be used for answering a particular research question.
    - The other members of the team are responsible for providing the “backend” functionality in a usable way (we will discuss details in the next weeks)

If in doubt about your project idea, please feel free to consult with the lecturers of the course.
When you are happy enough with your project idea, give the project a name and proceed to the next step.

## Project Repository on GitLab

With the project name, create a blank project repository on Git.UP. Set the “Visibility Level” to “private”. Invite the (other) team members with role “Developer” or “Maintainer”. As in the first project, invite  **TODO** Akshay Devkate (GitLab username devkate) with role “Reporter”, so that he can see your project, give feedback, and eventually access the project for grading.

## Project Structure

Prepare the project structure (directories `data, results, src/bin, docs` etc., depending on what you anBcipate to need for your project) and add the important files that you already know from the first project (README.md, license, citation information, .gitignore). The files can be left empty at this point. You can do this directly in the web interface of GitLab, or do it locally on a computer and commit to the remote repository later. Discuss advantages and disadvantages of both versions before you start working.

## Importan Files and Working with the Issue Tracker
Use the issue tracker to organize the work on the content of the files created above, and for adding some more files. Describe the issues, label them, assign them to someone. When the work is done, resolve the issue. Remember that you can discuss on issues during the
process.

Create issues for the following tasks:

    - Add a basic description of the project idea to the README.md. 
    - Add a license (after discussing with the team what license you want to use).
    - Prepare the citation.cff file.
    - Start the .gitgnore file.
    - Add a CONDUCT.md file to your project repository. Use the Contributor [Covenant Code of Conduct](https://www.contributor-covenant.org/) template and modify the places that need updaBng (e.g., who to contact).
    - Add a CONTRIBUTING.md file in the project to describe how other people can contribute to it (you can use the [GitHub contributors guide](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors) for inspiration).
    - Add a section to the README.md file of the project to tell people where to find out more about the code of conduct and the contribution guidelines

Use these fairly simple tasks to get used to working with the issue tracker. Discuss in your team the issue lifecycle that you want to follow in your project and test it with these tasks.
Using the issue tracker well will make the collaborative work on the project much easier