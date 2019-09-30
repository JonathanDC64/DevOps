# Git

- [Git](#git)
  - [The Need For Version Control](#the-need-for-version-control)
  - [Is it Git or GitHub](#is-it-git-or-github)
  - [Git Installation](#git-installation)
  - [git clone - Copy the contents of an existing Git repository](#git-clone---copy-the-contents-of-an-existing-git-repository)
  - [Identify yourself to Git](#identify-yourself-to-git)
  - [git init - Initialize empty repository in current folder](#git-init---initialize-empty-repository-in-current-folder)
  - [git add - Specifies which files to stage in the next commit](#git-add---specifies-which-files-to-stage-in-the-next-commit)
  - [git commit - Record cahnges to the repository](#git-commit---record-cahnges-to-the-repository)
  - [.gitignore - File that specifies which files and directories to not track](#gitignore---file-that-specifies-which-files-and-directories-to-not-track)
  - [git log - History of the git repository](#git-log---history-of-the-git-repository)
  - [git diff - Take 2 commits and compare the differences](#git-diff---take-2-commits-and-compare-the-differences)
  - [Using GitHub](#using-github)
  - [git push - Sends changes to remote repository](#git-push---sends-changes-to-remote-repository)
  - [git pull - Retrieve changes from remote repository](#git-pull---retrieve-changes-from-remote-repository)
  - [git fetch - Retrieve changes without modifying any files](#git-fetch---retrieve-changes-without-modifying-any-files)
  - [git branch - List, Create or Delete branches](#git-branch---list-create-or-delete-branches)
  - [git checkout - Change current branch](#git-checkout---change-current-branch)
  - [git merge - Join two or more branches](#git-merge---join-two-or-more-branches)
  - [git reset - Revert to a previous commit](#git-reset---revert-to-a-previous-commit)
  - [git rm - Remove files from working tree](#git-rm---remove-files-from-working-tree)

## The Need For Version Control

As DevOps is all about speed, efficiency, and collaboration,
there should be a version control system in place. Why?

Version controlling your code provides the following advantages:

- The ability to work on the same project by more than one person at the same time.
Each person will have a copy of the source code to do whatever changes required,
then changes are _merged_ with the main code,
after the necessary approvals.

- Protection against errors and failures by enabling developers
to go to and from different versions of the same code.
Debugging is greatly facilitated this way.

- Code can be _branched_. Developers can work on separate
branches of the source code to create and test new features.
At the end a branch can be merged with the main branch
(called master) or deleted.

## Is it Git or GitHub

Due to its huge popularity, some people confuse GitHub for Git.
Actually, they are two different things.

Git is the program used to version control your files.
It was created by Linus Torvalds (the creator of the Linux kernel)
in 2005.
It was to version control Linux kernel 2.6.12.

GitHub, on the other hand, is a web application that was launched
in 2008. It offers a version control repository that can be used
free of charge or for a fee (for private repositories).

git can integrate with GitHub so that the repository can be accessed
over the Internet from anywhere in the world instead of having
to create a local repository server.

GitHub is not the only Git repository service in the market.
There are similar products like BitBucket and GitLab.

## Git Installation

Most Linux installations come bundled with git.

Check with:

```bash
git --version
```

To install, go to [https://git-scm.com/download](https://git-scm.com/download)

Or run the commands:

```bash
# Ubuntu
sudo apt update
sudo apt install git

# CentOS
sudo yum -y install it
```

Installing from source:

```bash
# Ubuntu
git clone https://git.kernel.org/pub/scm/git/git.git
cd git/
sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev asciidoc xmlto docbook2x
make all doc info prefix=/usr
sudo make install install-doc install-html install-info install-man prefix=/usr

# CentOS
sudo yum -y groupinstall development
sudo yum install curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel aciidoc xmlto docbook2X
sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
git clone https://git.kernel.org/pub/scm/git/git.git
cd git/
make all doc info prefix=/usr
sudo make install install-doc install-html install-info install-man prefix=/usr
```

## git clone - Copy the contents of an existing Git repository

```bash
git clone URL

# Ex:
git clone https://git.kernel.org/pub/scm/git/git.git
```

## Identify yourself to Git

```bash
git config --global user.name "Your name"
git config --global user.email "Your email"
```

## git init - Initialize empty repository in current folder

The presence of a `.git` directory inside of your directory
means that this directory is being managed by git.

Git keeps tracks of all changes you make to any file in
your git repository that is not present in `.gitignore`

```bash
git init

# Check for .git directory
ls -la
# ...
# drwxrwxr-x.  7 vagrant vagrant   119 Sep 30 18:41 .git
# ...
```

## git add - Specifies which files to stage in the next commit

```bash
git add FILE_NAMES...

# Stage all changed files
git add .
```

## git commit - Record cahnges to the repository

Creates a snapshot of the repositories contents
at the current point in time (Based on staged files).

You must track files with `git add` before commiting.

```bash
git commit

# To attach message directly
git commit -m "MESSAGE"
```

## .gitignore - File that specifies which files and directories to not track

Create a file called `.gitignore`
and any pattern that matches the name of a file or directory
will not be tracked by git.

`.gitignore` example:

```gitignore
application/logs/*
!application/logs/index.html
!application/logs/.htaccess

composer.lock

user_guide_src/build/*
user_guide_src/cilexer/build/*
user_guide_src/cilexer/dist/*
user_guide_src/cilexer/pycilexer.egg-info/*
/vendor/

# IDE Files
#-------------------------
/nbproject/
.idea/*

## Sublime Text cache files
*.tmlanguage.cache
*.tmPreferences.cache
*.stTheme.cache
*.sublime-workspace
*.sublime-project
```

## git log - History of the git repository

The hash value after where `commit:` is uniquely identifies that commit.
This value is useful for when you need to refer to a specific commit.

```bash
git log
# commit d3ca022c19c19ebdc0338af91e0cc23a4d3ce2e5 (HEAD -> master)
# Author: Jonathan Del Corpo <jonathan_delcorpo@hotmail.com>
# Date:   Mon Sep 30 19:17:50 2019 +0000
#
#     Changed the database host
#
# commit fcbcbc99c5dbc532efb749da5293bd89386dcf5e
# Author: Jonathan Del Corpo <jonathan_delcorpo@hotmail.com>
# Date:   Mon Sep 30 19:05:47 2019 +0000
#
#     First commit
```

## git diff - Take 2 commits and compare the differences

```bash
git diff COMMIT_HASH1..COMMIT_HASH2

# Ex:
git diff d3ca022c19c19ebdc0338af91e0cc23a4d3ce2e5..fcbcbc99c5dbc532efb749da5293bd89386dcf5e
# diff --git a/application/config/database.php b/application/config/database.php
# index 05b9c7d..3b022ea 100644
# --- a/application/config/database.php
# +++ b/application/config/database.php
# @@ -75,7 +75,7 @@ $query_builder = TRUE;
#  
#  $db['default'] = array(
#         'dsn'   => '',
# -       'hostname' => 'localhost',
# +       'hostname' => '192.168.33.30',
#         'username' => 'ci_user',
#         'password' => 'cipassword',
#         'database' => 'ci_database',

# Reverse order of commits:
git diff fcbcbc99c5dbc532efb749da5293bd89386dcf5e..d3ca022c19c19ebdc0338af91e0cc23a4d3ce2e5
diff --git a/application/config/database.php b/application/config/database.php
# index 3b022ea..05b9c7d 100644
# --- a/application/config/database.php
# +++ b/application/config/database.php
# @@ -75,7 +75,7 @@ $query_builder = TRUE;
#  
#  $db['default'] = array(
#         'dsn'   => '',
# -       'hostname' => '192.168.33.30',
# +       'hostname' => 'localhost',
#         'username' => 'ci_user',
#         'password' => 'cipassword',
#         'database' => 'ci_database',
```

## Using GitHub

Make an account at [https://github.com/join](https://github.com/join)

Create a new repository at [https://github.com/new](https://github.com/new).

Do not select `Create Readme.md`

Copy you `.git` url.

Push your existing repository:

```bash
git remote add origin https://github.com/USERNAME/REPOSITORY_NAME.git

# `origin` refers to the name of the remote we added
# `master` refers to the branch to push your code to
git push -u origin master
```

## git push - Sends changes to remote repository

```bash
# Set default upstream location
git push --set-upstream origin master

git push
```

## git pull - Retrieve changes from remote repository

```bash
git pull
```

## git fetch - Retrieve changes without modifying any files

`git fetch` will give you information about any new commits
ahead of you without modifying any files in your directory.

Sometimes you may need to run `git fetch` before you can `git pull`

```bash
git fetch

# Check with:
git log master..origin/master

# And:
git diff HASH1 HASH2
```

## git branch - List, Create or Delete branches

Changes on one branch do not affect another branch unless
changes are explicitly pulled from another branch

Note: this will not automatically change your branch,
you need to do so manually with `git checkout`

```bash
git branch BRANCH_NAME

# View current list of branches
git branch

# Delete branch
git branch --delete BRANCH_NAME

# Delete branch on remote repository
git push --delete origin BRANCH_NAME
```

## git checkout - Change current branch

```bash
git checkout BRANCH_NAME

# Verify with:
git branch

# Push new branch to remote repository
git push -u origin BRANCH_NAME
```

## git merge - Join two or more branches

Can be used to combine the contents of several branches.

```bash
# Suppose we are in the master branch and we want to merge changes from another branch into master
git merge BRANCH_NAME
```

## git reset - Revert to a previous commit

```bash
# This will revert to another commit, but it will not change your files to that commit
# Useful for when there are certain changes in a portion of a file that you want to keep
git reset COMMIT_HASH

# Ex:
git reset c6e7ad1dff5536f8c665013b384411d06d79c53e

# This will revert to another commit and it will change the contents of your file to that commit
# However, any other changes may be also lost
# For example, you changed a file and some parts of the file you want to keep, some you want to discard
# This command will remove ALL changes, so you have yo be careful
git reset --hard COMMIT_HASH

# Check:
git log
```

## git rm - Remove files from working tree

Inform git that you have deleted a file.

```bash
git rm FILE_NAME
```
