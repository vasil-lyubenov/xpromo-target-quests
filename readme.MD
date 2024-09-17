Simple shell based script for extracting quest data for players data from Stillfront XPromo application.

Required jq for json parsing and prettifying.
MacOS: brew install jq
Windows: 
1. Chocolatey
choco install jq

2. Prebuild binaries
https://github.com/jqlang/jq/releases

How to use:
There are several arguments:
--guid : guid of the player which quests you want to check 
--api_key : The api key of your game
--sapi_key : The sapi key of your game
--target : if this argument is missing you will retrieve non targeted quests otherwise get target quests
--env {prod | dev | staging} : 
--title : the id of your title