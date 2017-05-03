# Community web application (based on Ruby on Rails Tutorial sample application)

This is a [Community web application](https://rails-community-app.herokuapp.com/) to meet needs 
of small communities like sport clubs and non-govermantal organisations.

This application is based on the sample application for 
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

## License
All source code in the [Community web application](https://rails-community-app.herokuapp.com/)
and in the [Ruby on Rails Tutorial](http://railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

## Automated tests with Guard

Use Guard to automate the running of the tests.

```
bundle exec guard
```

### Spring processes

Any time something isn’t behaving as expected or a process appears to be frozen, 
it’s a good idea to run 
```
ps aux | grep spring
```
to see what’s going on, and then run 

```
spring stop
```
To kill all the spring processes gunking up your system.

Sometimes this doesn’t work, though, and you can kill all the processes with name spring 
using the pkill command as follows:
```
pkill -15 -f spring
```

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).