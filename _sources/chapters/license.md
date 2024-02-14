#  Licenses, Software Citation and FAIR

In this chapter we will talk about what Licenses are and how they can be applied to research software. Furthermore, in this chapter we will explore the FAIR principles for research software including a pragmatic approach to FAIR.

## Licenses

Software licenses are crucial tools for both creators and users, they can be outlined as follows:

**Software as Intellectual Property**:

Like artwork, designs, and texts, software is considered intellectual property, a creation of the human mind deserving legal protection. This protection prevents unauthorized use and copying, giving creators control over their work.

**Common Forms of Protection**:

Copyright is the primary form of legal protection for software, safeguarding its code and functionality. Other relevant forms include patents (for unique algorithms or processes) and trade secrets (for confidential information).

**Software Licenses: Contracts for Use**:

A software license acts as a legal agreement between the owner (licensor) and the user (licensee). It grants permission to use the software under specific terms and conditions outlined in the agreement.

**What Licenses Define**:

Licenses typically specify: 

- The number of permitted installations.
- Commercial or non-commercial use allowed.
- Modification or distribution rights.
- Warranties and liabilities of the licensor.

**Importance of Licenses**:

Without a license, using copyrighted software is illegal. Licenses ensure legal and ethical use, protecting both creators and users.


There are numerous types of software licenses, ranging from free and open-source (e.g., GNU GPL) to paid commercial licenses with varying restrictions.
Understanding license terms is crucial before installing or using any software.
Breaching license terms can have legal consequences.

It is important think of Licenses when working with software, since they are vital for responsible and legal software use. Always take the time to read and understand the terms before using any software!

Fortunately, while there are a lot of different software licenses, there are only a few standard ones used.

### Types of software licenses

In general, there are three types of licenses.

#### Permissive licenses:
Allow users to use, modify, and distribute the work under certain conditions. They typically have few restrictions and allow for combination with other licenses.

#### Copyleft licenses:
Require that derivative works or modifications of the work be distributed under the same license terms. They aim to ensure that any improvements or modifications made to the work remain freely available to the community.

#### Proprietary licenses: 
Grant limited rights to use the work under specific conditions defined by the owner. These licenses usually restrict the redistribution, and modification of the work, or reverse engineering in case of software.

### Software and Data licenses 

Both are relevant in the context of research data and software Tend to use similar yet different licenses. The distinction arises from the inherent differences in their nature and the legal considerations associated with them, such as:

- Software is creative work, data is factual information

- Software is subject to copyright law, data may also be subject to privacy laws (sensitive data)

- Software licenses govern usage, modification and distribution of source code or executables.
 
- Data licenses address questions of access, usage, and sharing. 

- Continuously evolving practice in both fields.


### Common Open Source Software Licenses

#### MIT License:

- Permissive license allowing users to freely use, modify, and distribute the software.

- Requires including the original license and copyright notice in the distribution.

- Provides flexibility for commercial and proprietary use.

- Does not impose copyleft requirements on derivative works.

- Compatible with other licenses, including copyleft licenses.

The also popular **BSD** license is quite similar.

#### Apache License:

- Permissive license allowing users to use, modify, and distribute the software under certain conditions.

- Requires including the original copyright notice and license in distributions.
- Provides patent protection through a patent grant clause.

- Compatible with other licenses, including copyleft licenses.

- Promotes the combination of open-source and commercial software.

#### GNU General Public License (GPL):

- Copyleft license that ensures derivative works are also licensed under the GPL.
- Requires distributing the source code of the software when distributing the software itself.
- Encourages sharing and collaboration within the open-source community.

- Version 2 (GPLv2) is widely used and compatible with GPLv3 but less compatible with other licenses.

- Version 3 (GPLv3) includes additional provisions for patent protection.

### Creative Commons (CC) Licenses 

CC license are: 
A set of licenses used primarily for creative works, including artwork, literature, and media. They also are frequently used for data and other scientific outputs, but not recommended for software or hardware.
Various CC licenses exist, with different combinations of attribution, share-alike, and non-commercial clauses. They provides a framework for granting permissions and specifying usage restrictions. CC licenses offer flexibility in allowing creators to define the terms of use and distribution for their works.

CC Licenses offer varying levels of flexibility and restrictions, allowing creators to choose the terms that align with their desired balance between openness and control:

- Public Domain (**CC0**)
- Attribution (**CC BY**)
- Attribution-ShareAlike (**CC BY-SA**)
- Attribution-NoDerivs (**CC BY-ND**)
- Attribution-NonCommercial (**CC BY-NC**)
- Attribution-NonCommercial-ShareAlike (**CC BY-NC-SA**)
- Attribution-NonCommercial-NoDerivs (**CC BY-NC-ND**)

All CC licenses can be found [here](https://creativecommons.org/licenses/)

### Which License should you choose? 

Which license is the most suitable for your situation depends on a number of aspects:

- Do we want to license the work at all?
- Is the content we are licensing source code?
- Do we require people distributing derivative works to also distribute their code?
- Do we want to address patent rights?
- Is our license compatible with the licenses of the software we depend on?
- Do our institutions have any policies that may overrule our choices?
- Are there any copyright experts within our institution who can assist us?

You can get more help at: [Choosealicense.com](https://choosealicense.com/) 

**IMPORTANT:** **_Don’t write your own license. Legalese is a highly technical language, and words don’t mean what you think they do._**


## Software Publication and Citation
For decades, publishing peer-reviewed papers has been the cornerstone of scientific progress. Papers serve as crucial building blocks, allowing researchers to share findings, build upon existing knowledge, and receive credit for their work. However, the research ecosystem extends far beyond the written word. Data, code, and software play equally pivotal roles, yet their publication and citation remain significantly less common. This creates a gap that hinders transparency, reproducibility, and ultimately, scientific advancement.

#### A Broader Landscape:

Just as papers deserve publication and citation, so do other research outputs. Embracing this shift offers several benefits, aligned with key software citation principles:

**Importance and Credit & Attribution**: Sharing software alongside papers enhances transparency and empowers Research Software Engineers (RSEs). Formal citation practices give RSEs rightful credit for their contributions, adhering to the "Importance" and "Credit & Attribution" principles.

**Transparency and Unique Identification**: Making software openly available with persistent unique identifiers allows others to readily understand the "how" of research and identify the specific software version used ("Specificity" principle).

**Reproducibility and Persistence**: Openly available software enables others to run the same analyses, ensuring replicability and adherence to the "Persistence" principle.

**Collaboration and Accessibility**: Shared software fosters collaboration by offering reusable tools and codebases. This reduces duplication of effort, promotes community-driven development, and ensures the long-term sustainability of valuable research tools, fulfilling the "Accessibility" principle.


#### Making the Shift with Key Principles in Mind:

Several initiatives promote software publication and citation, aligned with these core principles:

- **Dedicated repositories**: Platforms like Zenodo and Software Heritage provide persistent, citable archives for research software, upholding the "Persistence" principle.

- **Citation guidelines**: Organizations like FORCE11 offer clear guidelines for formatting software citations in reference lists, ensuring "Specificity" and clarity.

- **Incentives and mandates**: Funding agencies and journals increasingly encourage or even mandate software publication as part of research outputs, promoting the overall importance of software.

By embracing these developments and adhering to these key principles, a research environment where software is valued, shared, and cited as readily as papers can be created. This shift will ultimately lead to more robust, transparent, and collaborative scientific progress, benefiting both researchers and society as a whole.

#### What could you do? 

- Advocate for software publication and citation within your research community and institutions.

- Utilize resources like the Zenodo guide for researchers to simplify software publication.

- Encourage colleagues to use dedicated repositories for long-term accessibility.

- Support the development of robust software citation metrics to properly acknowledge RSE contributions.

### How to Cite software?

Giving credit where credit is due applies to software just as much as any other intellectual creation. However, software citation can be tricky due to its unique nature. This guide explores how to identify the relevant metadata needed for proper software citation, highlighting resources like the Citation File Format (CFF) to make the process smoother.

#### Identifying the Relevant Metadata:
The ideal scenario is for the software project itself to clearly provide essential metadata for citation. This information typically includes:

- **Software name and version**: This seems obvious, but specifying the exact version ensures clarity and reproducibility.

- **Authors or developers**: Identify individuals or teams responsible for the software's creation.

- **Publication date or release date**: Pinpoint the initial release or significant update dates.

- **URL or access information**: Include links to official websites, repositories, or download locations.

- **DOI (Digital Object Identifier)**: If available, a DOI offers a persistent identifier for the software.

- **License information**: Specify the terms under which the software is distributed for proper ethical and legal attribution.

Unfortunately, not all software projects provide such detailed information. In such cases, consider these next steps:

- Consult the software website or documentation: Documentation often includes information about creators, release dates, and access details.

- **Search for publications** : Explore research papers or other publications related to the software's development. They often cite the software itself and might provide valuable metadata.

- Engage with the community forums or mailing lists: Reach out to the software's developer community for specific guidance on how to cite their work.

#### Enter the Citation File Format (CFF): 
The Citation File Format (CFF) offers a standardized way to store and share software citation metadata. 

Imagine it as a dedicated passport for your software, holding all the key information in a machine-readable format. Benefits of using CFF include:

- **Clarity and accuracy**: CFF ensures consistent and complete citation information, minimizing errors and ambiguity.
Tool support: Tools like cffinit help automatically generate CFF files from existing project data, streamlining the process.

- **Platform integration**: CFF can be integrated with platforms like Zenodo and GitHub, facilitating discovery and access to the software and its citation information.

- **Community adoption**: With over 16,000 CFF files already existing on GitHub, the format is gaining traction in the software development community.

Not all software projects utilize CFF yet. However, adopting this format demonstrates good scientific practice and encourages others to do the same, ultimately benefitting the entire research ecosystem.

In conclusion, citing software effectively requires identifying the relevant metadata, and resources like CFF make the process more efficient and standardized. 

### How to Publish Software

While making your software publicly available on platforms like GitHub is crucial for collaboration and access, it doesn't qualify as a formal "publication" in the academic sphere. To gain recognition and establish a proper citation record for your software, you need to follow specific strategies.

Here's how to effectively publish your software and ensure its academic merit:

#### 1. Publication Repositories:

- **Zenodo.org**: This open-access repository for research outputs allows you to upload your software along with associated data, documentation, and version control information. Zenodo assigns persistent identifiers (DOIs) for easy citation and tracking.

- **Figshare**: Another open-access platform, Figshare accepts various research artifacts, including software, and provides DOIs for citation. Similar to Zenodo, it offers version control and detailed metadata options.

#### 2. Software Journals:

- **Journal of Open Source Software (JOSS)**: A peer-reviewed, open-access journal dedicated to scientific software. Publication in JOSS involves a thorough review process ensuring software quality, reproducibility, and documentation clarity.

- **Journal of Research on Software (JORS)**: Similar to JOSS, JORS is a peer-reviewed open-access journal for software publications. It focuses on research software with significant contributions to scientific advancement.

- **Other options**: Explore discipline-specific software journals relevant to your field. Many engineering and computational sciences journals have dedicated software sections accepting peer-reviewed publications.

#### 3. "Publication" as a (Tools) Paper:

Consider writing a dedicated "tools paper" describing your software's development, methodology, functionalities, and impact. Submit this paper to relevant journals in your field, highlighting the software's contribution to your research area.

Ensure the paper clearly distinguishes itself from a user manual or technical documentation by focusing on the scientific significance and broader implications of your software.

#### 4. "Publication" in the Methods Section:

If your software is instrumental to your research findings, embed a detailed description of its functionality and development within the Methods section of your primary research paper.

Provide clear instructions on accessing and using the software, alongside a link to the publicly available code repository.

Additional considerations:

**Open Source Licensing**: Consider releasing your software under an open-source license like MIT or GPL to encourage contribution and wider adoption.
Version Control: Use a version control system like Git to track changes and ensure different versions are properly cited.

**Community Engagement**: Actively engage with users and developers on forums and platforms like GitHub to improve your software and foster a user community.
By following these strategies, you can effectively publish your software and gain the recognition it deserves within the academic community. Remember, formal publication goes beyond code availability and emphasizes transparency, reproducibility, and scientific contribution.

## FAIR Principles for Research Software (FAIR4RS)

In the age of information overload, ensuring the quality and usefulness of data is paramount. The FAIR principles offer a framework for managing data effectively, promoting its findability, accessibility, interoperability, and reusability.

```{figure} ../figures/fair/fair.png
:name: fair_princeples

FAIR 
```

- **Findability**: Think of data as hidden treasures. They need clear labels, descriptions, and identifiers (like unique file names) so people and machines can easily "discover" them. This means having rich metadata - information about the data itself, its format, context, and creation - that's searchable and discoverable through online repositories and catalogues.

- **Accessibility**: Once found, the treasure chest needs to be unlocked. Data should be readily accessible to authorized users. This requires clear access procedures, understandable licensing terms, and appropriate authentication processes. Consider factors like cost, technological barriers, and legal restrictions when defining accessibility.

- **Interoperability**: Imagine building with Lego bricks from different sets. Data interoperability ensures seamless integration with other datasets and analysis tools, regardless of format or origin. This requires using standardized vocabularies, data structures, and communication protocols. Think of it as creating a common language for different datasets to "talk" to each other.

-**Reusability**: Data should be more than just a one-time treasure trove. By having well-described metadata and clear documentation, data becomes reusable for future research, analysis, or even creative projects. This includes providing information about the data's limitations, provenance, and any modifications made. Reusability encourages collaboration, innovation, and maximizes the value of data beyond its initial purpose.

**_The FAIR principles are not just guidelines; they're essential for responsible data stewardship_**. By adhering to them, organizations, researchers, and individuals can unlock the true potential of their data, fostering research advancement, collaboration, and ultimately, knowledge creation.

Additional considerations:

- **Context is key** : The FAIR principles need to be applied within the specific context of the data and its intended use.

- **Community standards**: Existing community standards and best practices should be leveraged when implementing FAIR principles.

- **Technology can help**: Many tools and technologies exist to facilitate FAIR data management, from repositories to metadata creation platforms.

- **It's an ongoing process**: Implementing and maintaining FAIR data practices is an iterative process that requires continuous attention and collaboration.

## Pragmatic FAIR
