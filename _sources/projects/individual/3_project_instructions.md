# Project Assignment 4: Start Coding

In the last two weeks you already worked on your project: you selected a dataset, defined research questions, and set up the project repository on Git.UP. Now it’s time to start coding! More concretely, here is what we want you to do this week:

1. Always keep in mind what we discussed about **coding style**, and try to write readable code from the start. Feel free to make use of a linter and the checklist form the exercise above, generally refactor your code when you spot something that could be done better.

2. Use **plain .py** files for all your code for now (we will introduce Jupyter notebooks as an alternative next week). Which IDE you use does not matter (we have a preference for
Spyder, but no strong feelings about it). **TODO** DO WE???? 

3. Use your **research questions** as a starting point. Identify suitable methods to address them. For example, the ques1on “How has annual harvest for particular vegetables
developed (increased/decreased) in the past decade” could be answered with a line plot that has the years on the x-axis, the harvested amount in tons on the y-axis and differently
colored lines for a selec1on of vegetables included in the vegetable survey dataset. Then define separate **functions** for each of the research questions that implement these methods, plus additional utility functions for data loading etc.

4. Provide a **command-line interface** for using the implemented functionality, but at the same time make sure it can be imported as a library to other Python modules. (Recall the script template that we discussed in the third lecture.)

5. More likely than not, you will discover that the dataset that you downloaded originally is not completely fit to purpose, e.g., not suitably formated or including information that you do not need. Recall that the destatis/Genesis portal provides some configuration options before downloading the data, this might help with some issues. Still, some manual
**data cleaning** might be needed to bring you dataset in good shape for your analyses. You can do that in a spreadsheet program like MS Excel, but it is strongly recommended to
save the resulting table in CSV format for further processing.

6. Finally, do not forget to **commit** your work to your **Git.UP** repository regularly, so that you build up a version history and have your work in a safe place.