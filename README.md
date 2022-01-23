# File mover and time tracker apps

## File mover
### Functionality

We use the command to move all files from a chosen source directory to a target directory, the latter of which may or may not exist (and can be created upon request, optionally by the name derived from current date). In addition, we can specify what file endings to limit the move command to, by prepending the directory arguments with a `-t` flag followed by the desired filetype (e.g. `.txt`, NB remember the dot)

### Example usage

To move all files from `dirA` to `dirB`:

```bash
./move.sh dirA dirB
```
if `dirB` doesn't exist the user will be asked if he wishes to create it, abort, or create it and give it the name derived from the current date (y/n/time). (Instructions will be displayed on screen)

To only move the files which end with `.txt` from `dirA` to `dirB`:

```bash
./move.sh -t .txt dirA dirB
```

> Note: dirA (first directory argument) must exist. I also wouldn't try using `/` in dir names as that is already hardcoded when concatenating filenames with the optional (or the lack thereof) file ending, and no check exists to accomodate for multiple slashes.

## Time tracker

### Functionality

`track.sh` is used to start tasks with (optional) labels and to stop them, allowing to then display the log of completed tasks and their durations. It uses the file `~/.local/share/.timer_logfile` whose path is stored in the `$LOGFILE`, whose export is appended to `.bashrc` (don't ask me why, assignment specifications). Log of completed tasks and their durations is calculated from this file, and the contents of the file also control whether the user is allowed to start a new task (which is when the previous task has been completed) or stop the current one (which is when a task is already running). Only one task is allowed to run at any given point in time.


### Example usage

In a fresh bash session source the file: (also don't ask why we're doing sourcing and functions - assignment specification)

```bash
source track.sh
```
then you have access to the function `track`. To start timer:

```bash
track start [ label ]
```
If no label supplied then it defaults to `none` 

To stop the timer:

```bash
track stop
```

To view the completed tasks together with their labels and durations:

```bash
track log
```


