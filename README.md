# partners.api.ze

## Debugging
In order to attach to a docker container, you need to know what its ID is. Use docker ps to get a list of the running containers and their ids.

    docker ps

Then you can use the numeric ID to attach to the docker instance:

    docker attach 75cde1ab8133

It may not immediately show a rails console, but start typing and it should appear. If you keep this attached, it should show the rails console prompt the next time you hit the pry breakpoint.