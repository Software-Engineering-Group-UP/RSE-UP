# Project Assignment 1: Select a Dataset

In your first course project you will do an exploratory data analysis (EDA) on a dataset provided by the **Statistisches Bundesamt** (destatis, the national statistics office of Germany).

Exploratory data analysis means to analyze data sets by summarizing their main characteristics using descriptive statistics and visual methods. 
Formal modeling and hypothesis testing can be done, too, but does not have to be part of an EDA. Destatis has large amounts of data on a variety of topics, and typically in good quality, so it is a good
source to work with.

This first project assignment is about selecting a dataset that you want to work with: 
Go to the destatis Genesis online [portal](https://www-genesis.destatis.de/genesis/online/data?operation=sprachwechsel&language=en) or [the german language version](https://www-genesis.destatis.de/genesis/online) and browse through the topics and tables to find a dataset that you find interesting. 
It can be related to your study subject, but it does not have to be. Make sure that the dataset that you choose is not too small (there are some few tables which only contain a handful of data rows, that simply does not give a lot of possibilities for interesting analyses).

The “START the value retrieval” button under „Table retrieval” is very useful for a quick impression of datasets. Note that you can configure the table structure before starting the
retrieval, for example swapping rows and columns. Also, you can configure the range of years (default is often 10) and other atributes to be included. Keep this in mind for later, as
depending on the kind of analyses you want your program to perform, a particular structure of the table might be more convenient. With or without customization, we will finally have
to download the dataset in program-accessible form, i.e., ideally in CSV (comma-separated values) format. 

CSV files can be opened by spreadsheet programs like MS Excel or OpenOffice Calc, but are especially convenient for processing through own code.

When you have chosen a dataset, write a bit of text (not more than one page in A4 format) where you briefly state why you find this data interesting, describe the dataset in your own
words, and brainstorm about questions that you would like to get answered with the data. Just note these points down in plain text format somewhere for the moment, we will discuss
project structure and where to put such things next week. Also, don’t worry about how to implement all that with Python at this moment, we will also come to that later


*For example, might have chosen the table „[Harvested quantity (vegetables and strawberries)](https://www-genesis.destatis.de/genesis/online?operation=table&code=41215-0001&bypass=true&levelindex=1&levelid=1682331849908#abreadcrumb): [Germany, years, open-grown vegetables](https://www-genesis.destatis.de/genesis/online?operation=table&code=41215-0001&bypass=true&levelindex=1&levelid=1682331849908#abreadcrumb)“ (code [41215-0001](https://www-genesis.destatis.de/genesis/online?operation=table&code=41215-0001&bypass=true&levelindex=1&levelid=1682331849908#abreadcrumb)) from the “Vegetable survey”. I find this dataset interes:ng because I like ea:ng vegetables and I prefer to buy regional produce. The dataset contains data about the harvested quantities (in tons) of various kinds of vegetables grown in the open. Data are reported per year. Possible questions to answer with these data: 

`How has annual harvest for particular vegetables developed (increased/decreased) in the past decade?` 

`What are currently the most-grown vegetables in Germany?` 

`For which vegetables have the harvested quantities declined most?`

`How did vegetable produc:on in Germany change aUer 1989?`

```{figure} ../../figures/course_project/destatis.png
:name: destatis_example
Destatis Example
```

Remember that for this first project, everyone is expected to work on a topic individually. Do not hesitate to discuss about your chosen dataset with your fellow course mates, though. It is not a secret, and a bit of exchange often helps to get fresh ideas.

