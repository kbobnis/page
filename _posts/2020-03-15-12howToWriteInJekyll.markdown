---
layout: post
title:  "How to create a page, posts and write in jekyll"
date:   2020-03-15 09:11:26 +0100
categories: development
---
 
 
## Writing new posts

* Start with copying a template page (like this one) from `_posts` directory
* Change the name of the file to YYYY-MM-DD<pageTitle>.markdown
* Change the top \-\-\- portion of the file 
* open terminal and navigate to root of the project and type `bundle exec jekyll serve`
* open web browser with url `localhost:4000`
* after saving modified post file in text editor, jekyll will rebuild the page automatically and just refresh the page in browser
	* saving the `_config` file will not regenerate the page automatically. You have to stop and start the jekyll serve again

## Syntax
	
* I have the [https://www.markdownguide.org/basic-syntax/](https://www.markdownguide.org/basic-syntax/) opened at all times. 
* Lists
	* Unordered lists start with `*` (add a tab to indent list)
		1. Ordered lists
		1. Ordered lists
			1. Indented
			1. Indented
				* Unordered
* Heading `#` (start with two `##`, because heading `#` is reserved for page title)
* Escaping characters is done with `\`	
* Links: My favorite search engine SHOULD BE [Duck Duck Go](https://duckduckgo.com), but I use Google Chrome.


### Above but in markdown
```
* I have the [https://www.markdownguide.org/basic-syntax/](https://www.markdownguide.org/basic-syntax/) opened at all times. 
* Lists
	* Unordered lists start with `*` (add a tab to indent list)
		1. Ordered lists
		1. Ordered lists
			1. Indented
			1. Indented
				* Unordered
* Heading `#` (start with two `##`, because heading `#` is reserved for page title)
* Escaping characters is done with `\`	
* Links: My favorite search engine SHOULD BE [Duck Duck Go](https://duckduckgo.com), but I use Google Chrome.
```

> Too bad I have to remember copying the syntax to the markdown code below to have it updated.


## Installation of the whole web page

After you will have `gem` installed open terminal and here's quick start instructions (from site [jekyllrb.com](https://jekyllrb.com)):

```
gem install bundler jekyll
jekyll new my-awesome-site
cd my-awesome-site
bundle exec jekyll serve
```

Now browse to http://localhost:4000
