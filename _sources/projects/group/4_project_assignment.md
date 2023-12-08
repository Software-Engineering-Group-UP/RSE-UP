# Project Assignment 4: Testing and Error Handling

This assignment contains a set instructions of how to add testing and error handling to your group project.

## Testing and Error Handling

Testing is about trying to make programs fail. Appoint one person from the team as the responsible tester who tries to come up with comprehensive test cases that are suited to identify errors in the code (bugs). Follow the testing approaches discussed in the lecture:

- Use the pytest framework to run test (i.e., add `test_....py` files with `test_...` functions to your `bin/` or `src/` directory)
- Develop appropriate unit, integration and regressions tests.
- Check code coverage of the tests regularly, discuss with the team if more tests are needed.


The rest of the team should work on debugging the code (when tests idenfify problems), on adequate exception handling and on guarding the code against mistakes by adding assertions. Follow the guidelines for writing error messages discussed in the lecture.
Note: Some of you might already have experience with Con0nuous Integra0on to automate test execti0on. If you like, feel free to set up a CI pipeline for your project, but as we did not discuss it in the lecture, it is not required.


## Logging

Use Pythons logging framework to make your project report meaningful and differentiated status messages during execution of the code.