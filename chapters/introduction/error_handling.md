# Introduction to Error Handling

> "When Mister Safety Catch Is Not On, Mister Crossbow Is Not Your Friend."
>
> --- Terry Pratchett

We are imperfect people living in an imperfect world.
People will misunderstand how to use our programs,
and even if we test thoroughly as described in the previous chapter,
those programs might still contain bugs.
We should therefore plan from the start to detect and handle errors.

Something that goes wrong while a program is running
is sometimes referred to as an **exception** from normal behavior.Generally speaking,
we distinguish between two types of errors/exceptions.
**Internal errors**, are mistakes in the program itself,
such as calling a function with `None` instead of a list.
**External errors** are usually caused
by interactions between the program and the outside world:
a user may mis-type a filename,
the network might be down,
and so on.

When an internal error occurs,
the only thing we can do in most cases is report it and halt the program.
If a function has been passed `None` instead of a valid list,
for example,
the odds are good that one of our data structures is corrupted.
We can try to guess what the problem is and take corrective action,
but our guess will often be wrong
and our attempt to correct the problem might actually make things worse.
When an external error occurs on the other hand,
we don't always want the program to stop.
If a user mis-types her password,
handling the error by prompting her to try again
would be friendlier than halting and requiring her to restart the program.

This chapter looks at how we can raise, catch and handle errors.
We consider how to write useful error messages,
and how to make our programs log those messages
along with other useful information as they are running,
so that it's easier to figure out what happened when something goes wrong.

