###Gister

If you enjoy writing technical blogs like I do, you might have also experienced the pain of going back and forth between your blog and Github for 15 times to create gists in order to get some code snippets into your article. 

Well, fear no more. Gister is a tiny script that automates this process.

All you need to do is to put all the code you need gists for in one input file and Gister will create all the gists for you in seconds.

###Usage

As the example in example.txt, you will need to put all your code snippets inside an input file and separate them using the delimiter "$$$":

####Example input format
code snippet 1
$$$
code snippet 2
$$$
code snippet 3
$$$

####Example use case

Roys-MacBook-Pro:gister Roy$ ruby gister.rb 

Please enter your Github username or email. (The Github account you want to create gists on)

{github_username}

Please enter you Github password. (Password is needed becasue creating gist requires authentication)

{github_password}

Please enther the path to the file contains your input (Read README if you haven't)

example.txt

Please enter description for your gists

This is a demo 

Please enter name for gist. Please include extension for your gist so Github will highlight your code property (for
example, article.swift)

demo.swift

Enter 0 for private gist, enter 1 for public gist

1

authenticating ...

creating gists now ... 

gist created: https://gist.github.com/a24c1577299ccbdb1ed5cd4856b9f8e6

gist created: https://gist.github.com/127c59f6258efd5577db9e8e6ac72b44

gist created: https://gist.github.com/bf93064980a787e17a00a05ee353b954


Then you can paste these gists URLs directly into your blog.

###Licience

Just kidding, take and use it however you like.
