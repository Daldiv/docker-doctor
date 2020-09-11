This set of 3 BASH scripts where used to capture network diagnostic data on web server docker containers intermittently refusing connections. 

###################

Runs most of the standard open source shell network diagnostics tools and communicates to remote servers via SSH. THESE SRCIPTS DO NOT INSTALL THE NETWORK TOOLS, THOSE ARE MANUALLY INSTALLED ON THEIR RESPECTIVE MACHINES BY THE USER.

The scripts are quiet, and output everything to a txt file. If you wish to view or troubleshoot comment out the logging function documented within the scripts. When unpacking and the deploying the contents of any of these folders, the root destination folder must be ~/docker-doctor/$SCRIPT and not ~/docker-doctor/{control, remote}/$SCRIPT 

Don't forget to change the working varibales to match your scenario!

###################

There are 3 folders, "contol", "remote", "simple". If running a cluster or network of servers you might find useful the "control+remote" folders. If only working on an individual server then the "simple" folder might work best.

- "Control" contains the script on a control machine of a cluster/network. Quickly configure the variables pertaining to your situation then deploy the "remote" folder to your destination server.
- "Remote" contains the bulk of the scripts, this is where you'll find the commands that run the actual diagnostics tools.
- "Simple" contains a tiny script that runs CURL checks against predefined URL's and then logs the output quietly to a file.
