Opentshirts
===========

Opentshirts is the free open source t-shirt design module for Opencart eCommerce.

--------------------------------------------------------------------------------

If you are a develeper and want to contribute please follow the branchig model describer here
http://nvie.com/posts/a-successful-git-branching-model/

--------------------------------------------------------------------------------

This project follow Semantic Versioning 2.0.0
http://semver.org/

--------------------------------------------------------------------------------

In order to download lastest releases please go to 

http://github.com/opentshirts/opentshirts/releases

--------------------------------------------------------------------------------

If you are not doing a fresh install (you already have a production system up and running) DON'T FORGET TO BACKUP ALL THE FILES IN OPENCART FOLDER AND DATABASE FIRST!.

Fresh Install Instructions (Scroll down for upgrade instructions)

Requirements
First, you need an Opencart store installed on your server with vqmod system.
Please verify if the opentshirts version you are going to install is compatible with your Opencart version.

Steps
1- Upload all the files and folders in the opentshirt zip installer to your server in the same folder you have opencart installed.

2- Log in into your opencart admin, go to System-Users-User Groups, select Top Administrator, Edit, then select all for access and modify permission and save.

3- Go to Extensions-Modules, Find Opentshirts in the list and hit install.

4- Go to Extensions-Opentshirts-Printing Method and enable your preferred printing methods

5- Go to Extensions-Opentshirts-Install Packs and upload the Font Pack
Optionaly you can also upload the art sample pack in the same page.

6- Optionaly you can go to Extensions-Product Import/Export-Import and upload the default product packs (unzip before upload). If you find some trouble uploading the files check your values for Upload Max Filesize, Post Max size, Memory Limit, and Max Execution Time. They must be bigger the each zip file you upload.
If you dont see new categories in admin category list, click the repair button.

Upgrade Instructions

1- Upload all the files and folders in the opentshirt zip installer to your server in the same folder you have opencart installed.

2- Log in into your opencart admin, go to System-Users-User Groups, select Top Administrator, Edit, then select all for access and modify permission and save.

3- Go to Extensions-Modules, Find Opentshirts, click edit, then go to upgrade tab and click upgrade button.
