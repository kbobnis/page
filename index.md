---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

First sentence on a page.

### Public repositories


{% assign sorted_repos = site.github.public_repositories | sort: "name" | reverse %}
{% for repo in sorted_repos %}
  * [{{ repo.name }} ]({{ repo.html_url }})  
{% endfor %}


### FAQ 

1. Github LSF problem:
	* I have a problem with large files and they are already commited to my repo. Clear your history from those files using BFG: https://rtyley.github.io/bfg-repo-cleaner/


### My Naming conventions

Conventions

Naming (can use spaces)
 - projects: YYYY[.MM optional] <venue it was created at> - <name of the project>
 - <root>/docs subdirectory with images and other webpage related stuff
 - unity project will reside inside of unity/ directory

Files
 - <root>/README.md using a template (no template given yet)
  - README must contain at minimum:
   - Title (or "Noname"), a [game/app/tool] created [at game jam name | for something | ... ].
   - authors (name surname - role [music / programming)
   - screenshots or gif
   - Code is (not) playable.
   - State of the game: [playable / unplayable prototype | finished game]
   - Platform: 2 person coop on PC with xbox controller

Actions to do:
- create template project in github (for game jams at least)
- see if github supports metadata fields for repositories (authors, but can be more than just code contributors)