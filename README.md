# Spellbook Rails API: A Card, Deck, and Collection API for Magic the Gathering

This is a Rails API built for the [Spellbook](https://github.com/GuttermanA/spellbook) web application created as a final project at the Flatiron School. The API contains a PostgreSQL database seeded with the nearly 20,000 Magic: the Gathering Cards which is fully searchable on name and card type. Users can:

* Login with authentication
* View their saved decks and card collection
* View other user's decks
* Perform full CRUD action on their decks and collection
* Search a database of nearly 20,000 Magic cards
* Search for user decks

While this Rails app is built for my frontend, it has a fully functioning card database that you do not need authentication to use.

All deck and collection features require an account with a valid JWT token to use.

#### Demo

<a href="http://www.youtube.com/watch?feature=player_embedded&v=KreN1TQNLKM
" target="_blank"><img src="http://img.youtube.com/vi/KreN1TQNLKM/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

## API Routes

### Application Controller
```
GET /metadata_load
```
Used by the front-end to load formats, archtypes, sets, the card of the day and the deck of the day on initialization.

### Auth Controller
```
POST /login
```
Takes user name and password. If found, authenticates password. If authenticated, issues a JWT token and returns user data, decks, and collection.

### Cards Controller
```
GET /cards/search
```
Takes search params for cards and returns matching cards by type or name for up to 50 results. If passed default, will return 50 cards from the newest set in alphabetical order.

### Collection Controller
```
POST /collections
```
Takes an array of cards and adds them to a user's collection. Requires authentication.

```
PATCH /collections/:id
```
Takes card information and updates collection entry. Requires authentication.

```
DELETE /collections/:id
```
Takes card id and, if found, destroys given collection entry with id. Requires authentication.

### Decks Controller
```
POST /decks
```
Takes deck data in request body and creates deck. Requires authorization.

```
PATCH /decks/:id
```
Takes deck data in request body and updates deck of given id. Requires authentication.

```
DELETE /decks/:id
```
Deletes deck of given id. Requires authentication.

```
GET /decks/:id
```
Returns data for single deck of given id.

```
GET /decks/search
```
Takes search params for decks and returns matching deck names. If passed default as a search term, will return 50 of the most recently created decks.

```
DELETE /decks/:id
```
Takes deck id and, if found, destroys deck with given id. Requires authentication.

### User Controller
```
/signup
```
Takes username and password and creates user account. Issues JWT token.

## Installing
1. Clone repository from GitHub
2. Open terminal
3. Navigate to the repository directory
```
cd spellbook-api
```
4. Install gems
```
bundle install
```
5. Setup figaro
```
bundle exec figaro install
```
Generate secret for jwt_token and add to application.yml file. If required, add your postrges database admin account information to the application.yml file generated by figaro.

6. Setup database
```
rake db:create
```
```
rake db:migrate
```
```
rake db:seed
```
Will seed cards and decks. Will also create an admin account with password 1234 to be associated with seeded external decks.
**Note: seeding make take a while as the database is seeded by the [Magic: The Gathering Developers API](https://magicthegathering.io/). No API key required.

7. Turn on Rails cache for development
```
rails dev:cache
```
8. Start server
```
rails s
```

## Built With
* [Rails](http://rubyonrails.org/) - web-application framework
* PostgreSQL - database
* [MTG SDK - Ruby](https://github.com/MagicTheGathering/mtg-sdk-ruby) - data and seeding
* [Fast JSON API](https://github.com/Netflix/fast_jsonapi) - serializer
* [JWT](https://github.com/jwt/ruby-jwt) - authentication
* [Mechanize](https://github.com/sparklemotion/mechanize) - Web scraping for tournament decks
* [Nokigiri](https://github.com/sparklemotion/nokogiri) - Web scraping for tournament decks
* [Figaro](https://github.com/laserlemon/figaro) - DB account and secret configuration

## Contributing
1. Fork repository [here](https://github.com/GuttermanA/spellbook-api)
2. Create new branch for your feature
```
git checkout -b my-new-feature
```
3. Add and commit your changes
```
git commit -am 'Add some feature'
```
4. Push to your branch
```
git push origin my-new-feature
```
5. Create new pull request

## Authors
* Alexander Gutterman - [Github](https://github.com/guttermana)

## License

MIT © 2018 Alexander Gutterman

The information presented in this API about Magic: The Gathering, both literal and graphical, is copyrighted by Wizards of the Coast. This API is not produced, endorsed, supported, or affiliated with Wizards of the Coast.
