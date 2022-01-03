# General Info
***
This script is very useful to free space in logs directories or paths where some integration creates directories very often.
***
The script only needs one parameters:
1. CONFIG FILE -> This file content three variables:
   * LOG_NAME: The log name where it will be saved the trace of the execution (it includes files and directories deleted)
   * DIR_LOGS: The path where it will be saved the LOG_NAME (logs will be rotating with each execution)
   * PATH_LIST: This file content the paths to clean and the policy of retention for each path.
***
I suggest run the script via cron, and you just have to add/delete the paths in PATH_LIST file when it needed.
