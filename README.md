# partners.api.ze

## Testing

    docker-compose run -e "RAILS_ENV=test" partners_api bundle exec rspec

## Debugging

    docker ps

Then you can use the numeric ID to attach to the docker instance:

    docker attach 75cde1ab8...

It may not immediately show a rails console, but start typing and it should appear. If you keep this attached, it should show the rails console prompt the next time you hit the pry breakpoint.