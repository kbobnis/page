## Krzysztof Bobnis

### My public repositories

{% for repository in site.github.public_repositories %}
  * [{{ repository.name }}]({{ repository.html_url }})
{% endfor %}


### FAQ 
1. I have a problem with large files and they are already commited to my repo. 
   * clear your history from those files using BFG: https://rtyley.github.io/bfg-repo-cleaner/
