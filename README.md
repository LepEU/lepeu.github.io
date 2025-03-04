# Description

This is the repo for LepEU's public facing web page. If you want to join LepEU check out the Join Us page on https://lepeu.github.io


## 1. General procedure to update pages

1. You need to be a member of the LepEU to edit this page. If you are not a member and want to join see **Description** above
2. Make a new branch on the github interface of this branch, name the branch with the following convention: `yourname-typeofchange-number`
   Examples of `typeofchange` can be `edit` or `update` etc. The `number` field is optional but may help you keep track of your branches if you are making lots of edit
3. Once on your branch, use the the pencil icon on the top right to edit the relevant .qmd file. This are standard quarto **markdown** files and so you can use markdown for your formatting pleasure.
4. Once you have made your changes, hit the green `Commit changes...` but on the top right.
5. Merge your branch with `main` branches
6. Go back to main page of the repo, select our branch if it is not selected already and hit `Compare and Pull Request`
7. Make sure to enter the required descriptions for the Pull Request
8. If you want somone to review your work before merging with the main page, you can pick some one now
9. If there no conflicts you can safely merge your changes with the main page and delete the branch you created.
10. Changes to the pages should appear in a few minutes.

## 2. How to add a news item

We have a dedicated blogstyle [news page](https://lepeu.github.io/news.html). To add additional news items you need need to follow the instructions above
in how to edit pages [in general](#1-general-procedure-to-update-pages). When adding a news item, please also pay attention to the following:

1. In your new branch, make a new folder under the "news" folder and call it something meaningful
2. Inside your new folder you need to put your content in a file called `index.qmd`, copy the content from the index.qmd in /news/2024-09-17-cost_action_signup
and use this templated to add your content. Any additional media or content on your news page should also be in this folder.
3. Once you are done editing your `index.qmd` page and added any media you want to use, just follow the process above to Commit changes, Compare and Pull request, and then finally merge (feel free to delete your branch at this point).
4. If nothing is broken, your news item should be visible on the page in a few minutes.

## 3. How to add your info on members page

Member information is displayed on the [members page](https://lepeu.github.io/members.html). This page currently displays member name, affiliation and an image. Clicking on the our info
leads to a page for further information. Additionally, members are grouped into regions north, central, south and other. Here's what to do if you want to add your info:

1. Make a new branch as [above](#1-general-procedure-to-update-pages). Make a .qmd file titled: `YourFirstNameYourLastName.qmd` in the relevant folder (north, central, south, other) under the `members` folder.
2. Add your image in this folder as well.
3. Copy the contents of `members/north/saadarif.qmd` in to the .qmd file you made and edit the content to reflect your profile.
4. Once you are done editing your `.qmd` page with your info, just follow the process above to Commit changes, Compare and Pull request, and then finally merge (feel free to delete your branch at this point).
5. If nothing is broken, your news item should be visible on the page in a few minutes.

## 4. Getting help

If you need help with anything or want to me add your info, news item, or anything else, email me at <sarif@brookes.ac.uk>.
 



