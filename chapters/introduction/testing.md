# Introduction to Testing

> Opera happens because a large number of things amazingly fail to go wrong.
>
> --- Terry Pratchett

We have written software to count and analyze the words in classic texts,
but how can we be sure it's producing reliable results?
The short is answer is that we can't---not completely---but
we can test its behavior against our expectations to decide if we are sure enough.
This chapter explores ways to do this,
including assertions, unit tests, integration tests, and regression tests.

> **A Scientist's Nightmare**
>
> Why is testing research software important?
> A successful early career researcher in protein crystallography,
> Geoffrey Chang,
> had to retract five published papers---three from
> the journal *Science*---because his code had
> inadvertently flipped two columns of data [{cite:p}`Mill2006`].
> More recently, a simple calculation mistake in a paper by Reinhart and Rogoff
> contributed to making the financial crash of 2008 even worse
> for millions of people [{cite:p}`Borw2013`].
> Testing helps to catch errors like these.
