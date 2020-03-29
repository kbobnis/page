---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

This blog is part of [kblb](https://kblb.github.io/) group. Every article about tech is cross-posted there.

## My Public repositories

{% assign sorted_repos = site.github.public_repositories | sort: "name" | reverse %}
{% for repo in sorted_repos %}
  * [{{ repo.name }} ]({{ repo.html_url }})  
{% endfor %}


### FAQ 

1. Github LSF problem:
	* I have a problem with large files and they are already commited to my repo. Clear your history from those files using BFG: https://rtyley.github.io/bfg-repo-cleaner/
