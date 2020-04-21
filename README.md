# partners.api.ze

## About

This application allow us to:
- **Create** a point of sale(POS) with a `coverage_area` field;
- **Search** POS based on a geolocation point if this point is within coverage area;
- **Retrieve** POS by id.

#### Was built using:
- Ruby 2.5
- MySql 5.7
- Rails 5.2.4.2

#### Structure
- controller (*actions statements*)
  - shared (*controller helpers*)
    - params_validations
    - permitted_params
- errors (*custom errors*)
- generators (*data transformation*)
- models (*declared models*)
  - representations (*structure to expose models*)
  - validators (*custom fileds validation*)
- parsers (*converting external params to application model*)
- spec (*tests*)

**This applications was built using a rails way... We know that to improve maintenability we should use some approaches like Interfaces. We know that we would need an interface to `parsers` case we need receive **xml** for example, or a `repository layer` to change databases with less headcache and more else.*

## Running

Build docker images:

    docker-compose build

Running application on background(`-d`)

    docker-compose up -d

The **application** will running on port `3001` and **database** on `3307`

## Debugging

To debugging some piece of code, use `binding.pry` as a break point. To debugging we need attach to our docker

    docker attach partners-api

**We need container running before debugging*

*It may not immediately show a rails console, but start typing and it should appear. If you keep this attached, it should show the rails console prompt the next time you hit the pry breakpoint.*

To know shortcuts to navigate on debugging look at: `pry-nav` [gem](https://github.com/nixme/pry-nav#pry-nav)

## Testing

    docker-compose run -e "RAILS_ENV=test" partners_api bundle exec rspec

**We need build images before running tests*

## How to scale?

Before try changes the database to a better spatial database, we need try some approaches to improve, if we have big polygons we can try:
  - Simplification our polygons (*to reduce points/sides therefore reducind slow queries*)
  - Segmentation our polygons(*breaking large polygons we can reduce slow queries*)
