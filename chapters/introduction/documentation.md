# Introduction to writing Documentation

In the following Chapter you will learn about writing documentations suitable for research software projects and software projects in general.

First you will learn what Markdown files are and how to use them, after that we will give an introduction into what a README file is in Git repositories, before moving on to the next section [Documentation](https://software-engineering-group-up.github.io/RSE-UP/chapters/writing_documentation.html)


## Markdown Files

Markdown, a free and open-source markup language, is today one of the most commonly used languages, that we use to write documentation in. Known for its lightweight and intuitive syntax, it allows writers to create simple formatted documents without getting bogged down in complex code. Unlike word documents markdown files can be opened with any text editor. And there are hardly any formations problem accross systems since it is basicly just plain text, using simple symbols and punctuation to achieve desired styles.

What makes Markdown special:

- Readability: Markdown documents are easy to read and understand, both in 
  their raw form and when converted to other formats. 
  This makes them perfect for collaborative work and version control.

- Versatility: Markdown is not limited to a single output format. 
  It can be seamlessly converted to HTML, PDF, Word, and many others, making it
  adaptable to various platforms and needs.

- Customization: While designed for simplicity, Markdown doesn't lack power. 
  For complex formatting or specific layouts, it allows embedding inline HTML 
  code, giving you granular control over your document's appearance.

- Efficiency: Writing in Markdown is fast and efficient.

- Ubiquity: Markdown's popularity has skyrocketed in recent years. 
  It's widely used for documentation, README files, blog posts, online forums, 
  and even entire books. Many platforms and applications, like GitHub, 
  Stack Overflow, and Medium, natively support Markdown, 
  making it a valuable tool for any online writer.

Getting started with Markdown is easy:

- Learn the basics: Start by familiarizing yourself with the core syntax elements
like headings, bold, italics, lists, and quotes. Many online resources offer interactive tutorials and cheat sheets.

- Practice: Experiment with different formatting options and discover how they work.

- Use Markdown-enabled platforms: Explore tools and websites that integrate seamlessly with Markdown, making the writing and publishing process smooth and efficient.

With its simplicity, versatility, and growing community, Markdown offers a powerful and accessible way to format text online. So, ditch the complex editors and embrace the clean elegance of Markdown – your writing will thank you for it!

### Syntax
Markdown's intuitive syntax uses plain text characters to format your documents, making it easy to read and write while offering powerful customization options. Let's explore the key elements:

### **Basic Syntax:**
- Heading: Start with # signs for different heading levels (e.g., # H1, ## H2, ### H3, etc.)

- Bold font: Surround text with double asterisks (**) or underscores (_).

-Italic font: Use asterisks (*) or underscores (_).

- Blockquote: Indent text by four spaces or start with a greater-than symbol (>).

- Ordered List: Start each item with a number followed by a dot (.).

- Unordered List: Use hyphens (-) or asterisks (*) for each item.

- Code: Wrap inline code with single backticks (`) or create code blocks with three backticks on separate lines.

- Horizontal Rule: Use three hyphens (-), underscores (_), or asterisks (*).
- Link: Write text you want to display in square brackets and the actual URL in parentheses, separated by a space (Link Text: https://example.com).

- Image: Use an exclamation mark (!), followed by alt text in square brackets, then the image URL in parentheses, and an optional title in quotes (Alt Text: [[invalid URL removed]]([invalid URL removed]) "Image Title").

#### **Extended Syntax: (Not all platforms support all features)**

- Table: Create columns with pipes (|) and define headers and content in separate rows.

```
| Column 1 | Column 2 |
|---|---|
| Header 1 | Content 1 |
| Header 2 | Content 2 |
```

- Fenced Code Block: Use three backticks or tildes to highlight code with optional language specification (python code).

- Footnote: Use superscript number after text and define the footnote below with the same number in square brackets and the content, enclosed in parentheses.

- Heading ID: Add an ID after a heading enclosed in curly braces (e.g., ### My Heading {#custom-id}).

- Definition List: Define terms and their meanings with colon (:) separation.
- Strikethrough: Wrap text with two tildes (~).

- Task List: Use hyphens (-) followed by square brackets ([ ]) and checkboxes (x) for completed tasks.

```
- [ ] Buy groceries
- [x] Clean the house

```
- Emoji: Use emoji unicode characters directly (e.g., :smile:).

- Highlight: Wrap text with two equal signs (=) for inline highlighting or use syntax specific to your platform for code highlighting.

- Sub-/Superscript: Use tilde (~) for subscript (H~2~O) and caret (^) for superscript (X^2^).

Remember, this is just a starting point. Explore different platforms and resources to discover further functionalities and unleash the full potential of Markdown!

## README Files

```{figure} ../../figures/documentation/readme.png
:name: readme_git
A README.md inside a Git repository
```

A README file, typically named **README.md** in Git projects, is the first point of contact for anyone encountering your open-source project. 


It serves as a comprehensive introduction and guide, aiming to:

- Orient users: Newcomers can quickly grasp the purpose, features, and benefits of your project.

- Empower contributors: Developers understand contributing guidelines, workflows, and coding standards.

- Provide essential information: Users readily access installation instructions, usage guides, and documentation links.

- Encourage engagement: The README fosters a welcoming and participatory atmosphere for your project community.

### Key characteristics of a good README:

 - Conciseness: Keep it brief and to the point, highlighting the most crucial information.

- Clarity: Use clear and easy-to-understand language, suitable for various technical backgrounds.

- Structure: Organize information logically and visually appealingly, making it easy to navigate.

- Accessibility: Ensure good formatting and markdown usage for optimal readability across platforms.

By crafting a compelling and informative README, you can attract users, guide contributors, and establish a solid foundation for your open-source project's growth and success.

### Key Components of a README: 

- Project Overview: Briefly describe the purpose and goals of the project. 
  Explain what problem it solves or what functionality it provides.

- Installation Instructions: Provide step-by-step instructions on how to 
  install and set up the project. Include any dependencies, prerequisites, or 
  system requirements.

- Usage Guide: Explain how to use the software, including any command-line 
  options, configuration settings, or APIs. Provide code examples or usage 
  scenarios to help users get started.

- Features: List the main features and capabilities of the software. Highlight 
  unique or notable functionalities.

- Documentation: Provide links or instructions to access additional 
  documentation, such as user guides, API references, or tutorials.

- Contribution Guidelines: If you welcome contributions from the community, 
  outline guidelines for how others can contribute, such as reporting issues, 
  submitting pull requests, or participating in discussions.

- License: Specify the license under which the software is distributed. Mention
  any restrictions or permissions regarding usage, modification, and 
  redistribution.

- Changelog: Include a brief history of notable changes, bug fixes, and new 
  features for each version of the software.

- Contact Information: Provide a way for users and contributors to contact you 
  or the project team, such as an email address or a link to a communication 
  platform (e.g., GitHub Issues).

- Acknowledgments: Give credit to individuals or organizations that have 
  contributed to the project or provided inspiration or support.

**Note**:
If not applicable to a project, components can be omitted. 
If very extensive, content can go into a separate file and a short description with a link into the README.
