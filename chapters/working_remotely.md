# Working Remotely 

When the Internet was young, people didn't encrypt anything except the most sensitive information when sending it over a network.
However, this meant that villains could steal usernames and passwords.
The **SSH protocol** was invented to prevent this (or at least slow it down).
It uses several sophisticated (and heavily tested) encryption protocols
to ensure that outsiders can't see what's in the messages
going back and forth between different computers.

To understand how it works,
let's take a closer look at what happens when we use the shell
on a desktop or laptop computer.
The first step is to log in
so that the operating system knows who we are and what we're allowed to do.
We do this by typing our username and password;
the operating system checks those values against its records,
and if they match,
runs a shell for us.

As we type commands,
characters are sent from our keyboard to the shell.
It displays those characters on the screen to represent what we type,
and then executes the command and displays its output (if any).
If we want to run commands on another machine, such as the server in the basement that manages our database of experimental results, we have to log in to that machine so that our commands will go to it instead of to our laptop.
We call this a **remote login**.

## Logging In 

In order for us to be able to log in,
the remote computer must run a **remote login server** and we must run a program that can talk to that server.
The client program passes our login credentials to the remote login server;
if we are allowed to log in, that server then runs a shell for us on the remote computer (Figure [SSH](ssh-ssh)).

```{figure} ../figures/ssh/ssh.png
:name: ssh-ssh
The local client connects to the remote login server, which starts a remote shell (solid lines). Commands from the local client are passed to the remote shell and output is passed back (dashed lines).```

Once our local client is connected to the remote server,
everything we type into the client is passed on, by the server, to the shell
running on the remote computer.
That remote shell runs those commands on our behalf,
just as a local shell would,
then sends back output, via the server, to our client, for our computer to display.

The remote login server which accepts connections from client programs
is known as the **SSH daemon**, or `sshd`.
The client program we use to log in remotely is the **secure shell**,
or `ssh`.
It has a companion program called `scp`
that allows us to copy files to or from a remote computer using the same kind of encrypted connection.

We issue the command `ssh username@computer` to log in remotely.
This command tries to make a connection to the SSH daemon running on the remote computer we have specified.
After we log in,
we can use the remote shell to use the remote computer's files and directories.
Typing `exit` or Control-D
terminates the remote shell, and the local client program, and returns us to our previous shell.

In the example below,
the remote machine's command prompt is `moon>`
instead of `$` to make it clearer which machine is doing what.

```bash
$ pwd
```

```text
/Users/amira
```

```bash
$ ssh amira@moon.euphoric.edu
Password: ********
```

```bash
moon> hostname
```

```text
moon
```

```bash
moon> pwd
```

```text
/Users/amira
```

```bash
moon> ls -F
```

```text
bin/     cheese.txt   dark_side/   rocks.cfg
```

```bash
moon> exit
```

```bash
$ pwd
```

```text
/Users/amira
```

## Copying Files 

To copy a file,
we specify the source and destination paths,
either of which may include computer names.
If we leave out a computer name,
`scp` assumes we mean the machine we're running on.
For example,
this command copies our latest results to the backup server in the basement,
printing out its progress as it does so:

\newpage

```bash
$ scp results.dat amira@backup:backups/results-2019-11-11.dat
Password: ********
```

```text
results.dat              100%  9  1.0 MB/s 00:00
```

Note the colon `:`, separating the hostname of the server and the pathname of
the file we are copying to.
It is this character that informs `scp` that the source or target of the copy is
on the remote machine and the reason it is needed can be explained as follows:

In the same way that the default directory into which we are placed when running
a shell on a remote machine is our home directory on that machine, the default
target, for a remote copy, is also the  home directory.

This means that:

```bash
$ scp results.dat amira@backup:
```

would copy `results.dat` into our home directory on `backup`, however, if we did not
have the colon to inform `scp` of the remote machine, we would still have a valid command:

```bash
$ scp results.dat amira@backup
```

but now we have merely created a file called `amira@backup` on our local machine,
as we would have done with `cp`.

```bash
$ cp results.dat amira@backup
```

Copying a whole directory between remote machines uses the same syntax as the `cp` command:
we just use the `-r` option to signal that we want copying to be recursive.
For example,
this command copies all of our results from the backup server to our laptop:

```bash
$ scp -r amira@backup:backups ./backups
Password: ********
```

```text
results-2019-09-18.dat              100%  7  1.0 MB/s 00:00
results-2019-10-04.dat              100%  9  1.0 MB/s 00:00
results-2019-10-28.dat              100%  8  1.0 MB/s 00:00
results-2019-11-11.dat              100%  9  1.0 MB/s 00:00
```

## Running Commands 

Here's one more thing the `ssh` client program can do for us.
Suppose we want to check whether we have already created the file
`backups/results-2019-11-12.dat` on the backup server.
Instead of logging in and then typing `ls`,
we could do this:

```bash
$ ssh amira@backup "ls results*"
Password: ********
```

```text
results-2019-09-18.dat  results-2019-10-28.dat
results-2019-10-04.dat  results-2019-11-11.dat
```

Here, `ssh` takes the argument after our remote username
and passes it to the shell on the remote computer.
(`ls results` has multiple words, so we have to put quotes around it to make it look like one value.)
Since those arguments are a legal command,
the remote shell runs `ls results` for us
and sends the output back to our local shell for display.

## Creating Keys 

Typing our password over and over again is annoying,
especially if the commands we want to run remotely are in a loop.
To remove the need to do this, we can create an **SSH key** to tell the remote machine that it should always trust us.

SSH keys come in pairs, a public key that gets shared with services like GitHub,
and a private key that is stored only on our computer. If the keys match,
we are granted access.
The cryptography behind SSH keys ensures that no one can reverse-engineer our
private key from the public one.

We might already have an SSH key pair on our machine.
We can check by moving to our `.ssh` directory and listing the contents.

```bash
$ cd ~/.ssh
$ ls
```

If we see `id_rsa.pub`,
we already have a key pair and don't need to create a new one.

If we don't see `id_rsa.pub`,
this command will generate a new key pair.
(Make sure to replace `your@email.com` with your own email address.)

```bash
$ ssh-keygen -t rsa -C "your@email.com"
```

When asked where to save the new key,
press enter to accept the default location.

```text
Generating public/private rsa key pair.
Enter file in which to save the key
(/Users/username/.ssh/id_rsa):
```

We will then be asked to provide an optional passphrase.
This can be used to make your key even more secure,
but if we want to avoid typing our password every time,
we can skip it by pressing enter twice:

```text
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

When key generation is complete,
we should see the following confirmation:

```text
Your identification has been saved in
/Users/username/.ssh/id_rsa.
Your public key has been saved in 
/Users/username/.ssh/id_rsa.pub.
The key fingerprint is:
01:0f:f4:3b:ca:85:d6:17:a1:7d:f0:68:9d:f0:a2:db your@email.com
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
|        . E +    |
|       . o = .   |
|      . S =   o  |
|       o.O . o   |
|       o .+ .    |
|      . o+..     |
|       .+=o      |
+-----------------+
```

(The random art image is an alternate way to match keys.)
We now need to place a copy of our public key on
any servers we would like to connect to.
Display the contents of our public key file with `cat`:

```bash
$ cat ~/.ssh/id_rsa.pub
```

```text
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA879BJGYlPTLIuc9/R5MYiN4yc/
YiCLcdBpSdzgK9Dt0Bkfe3rSz5cPm4wmehdE7GkVFXrBJ2YHqPLuM1yx1AUxIe
bpwlIl9f/aUHOts9eVnVh4NztPy0iSU/Sv0b2ODQQvcy2vYcujlorscl8JjAgf
WsO3W4iGEe6QwBpVomcME8IU35v5VbylM9ORQa6wvZMVrPECBvwItTY8cPWH3M
GZiK/74eHbSLKA4PY3gM4GHI450Nie16yggEg2aTQfWA1rry9JYWEoHS9pJ1dn
LqZU3k/8OWgqJrilwSoC5rGjgp93iu0H8T6+mEHGRQe84Nk1y5lESSWIbn6P63
6Bl3uQ== your@email.com
```

Copy the contents of the output,
then log in to the remote server as usual:

```bash
$ ssh amira@moon.euphoric.edu
Password: ********
```

Paste the copied content at the end of `~/.ssh/authorized_keys`.

```bash
moon> nano ~/.ssh/authorized_keys
```

After appending the content,
log out of the remote machine and try to log in again.
If we set up the SSH key correctly, we won't need to type our password:

```bash
moon> exit
```

```bash
$ ssh amira@moon.euphoric.edu
```

## Dependencies 

The example of copying our public key to a remote machine, so that it
can then be used when we next SSH into that remote machine, assumed
that we already had a directory `~/.ssh/`.

While a remote server may support the use of SSH to log in, your home
directory there may not contain a `.ssh` directory by default.

We have already seen that we can use SSH to run commands on remote
machines, so we can ensure that everything is set up as required before
we place the copy of our public key on a remote machine.

Walking through this process allows us to highlight some of the typical
requirements of the SSH protocol itself, as documented in the man page
for the `ssh` command.

Firstly, we check that we have a `.ssh/` directory on another remote
machine, `comet`

```bash
$ ssh amira@comet "ls -ld ~/.ssh"
Password: ********
```

```text
ls: cannot access /Users/amira/.ssh: No such file or directory
```

Oops:
we should create the directory and check that it's there:

```bash
$ ssh amira@comet "mkdir ~/.ssh"
Password: ********
```

```bash
$ ssh amira@comet "ls -ld ~/.ssh"
Password: ********
```

```text
drwxr-xr-x 2 amira amira 512 Jan 01 09:09 /Users/amira/.ssh
```

Now we have a `.ssh` directory, into which to place SSH-related
files, but we can see that the default permissions allow anyone to
inspect the files within that directory.
This is not considered a good thing for a protocol that is supposed to be secure,
so the recommended permissions are read/write/execute
for the user, and not accessible by others.

Let's alter the permissions on the directory:

```bash
$ ssh amira@comet "chmod 700 ~/.ssh; ls -ld ~/.ssh"
Password: ********
```

```text
drwx------ 2 amira amira 512 Jan 01 09:09 /Users/amira/.ssh
```

That looks much better.

In the above example, it was suggested that we paste the content of
our public key at the end of `~/.ssh/authorized_keys`, however as
we didn't have a `~/.ssh/` on this remote machine, we can simply
copy our public key over as the initial `~/.ssh/authorized_keys`,
and of course, we will use `scp` to do this, even though we don't
yet have passwordless SSH access set up.

```bash
$ scp ~/.ssh/id_rsa.pub amira@comet:.ssh/authorized_keys
Password: ********
```

Note that the default target for the `scp` command on a remote
machine is the home directory, so we have not needed to use the
shorthand `~/.ssh/` or even the full path `/Users/amira/.ssh/` to
our home directory there.

Checking the permissions of the file we have just created on
the remote machine, also serves to indicate that we no longer
need to use our password, because we now have what's needed
to use SSH without it.

```bash
$ ssh amira@comet "ls -l ~/.ssh"
```

```text
-rw-r--r-- 2 amira amira 512 Jan 01 09:11
/Users/amira/.ssh/authorized_keys
```

While the authorized keys file is not considered to be highly sensitive
(after all, it contains public keys), we alter the permissions to match
the man page's recommendations.

```bash
$ ssh amira@comet "chmod go-r ~/.ssh/authorized_keys; ls -l
~/.ssh"
```

```text
-rw------- 2 amira amira 512 Jan 01 09:11
/Users/amira/.ssh/authorized_keys
```
