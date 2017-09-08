# Community web application

This is a [Community web application](https://rails-community-app.herokuapp.com/) to meet needs 
of small communities like sport clubs and non-governmental organisations.

This application is based on the sample application for 
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/). Thank you for this great Rails tutorial!

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

### Automated tests with Guard

Use Guard to automate the running of the tests.

```
$ bundle exec guard
```

## Production webserver

This app uses Puma webserver that is suitable for production applications on Heroku platform (cloud platform as a service). 
See [Heroku Puma documentation](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server).

### Heroku application setup

You have to create and configure a new Heroku account. 
The first step is to [sign up for Heroku](http://signup.heroku.com/). 
Then check to see if your system already has the 
[Heroku command-line client installed](https://devcenter.heroku.com/articles/heroku-cli):

```
$ heroku version
```

Use the Heroku command to log in and 
[add your SSH key](https://help.github.com/articles/connecting-to-github-with-ssh/):

```
$ heroku login
$ heroku keys:add
```
Finally, use the Heroku create command to create a place on the Heroku servers for the 
community app to live:

```
$ Heroku create
```

Rename the application as follows:

```
$ heroku rename <your-heroku-app>
```

#### Custom domain

In addition to supporting subdomains, Heroku also supports custom domains.
See the [Heroku documentation](http://devcenter.heroku.com/) 
for more information about custom domains.

#### SSL

If you want to run SSL on a custom domain, such as www.example.com, refer to 
[Heroku’s documentation on SSL](http://devcenter.heroku.com/articles/ssl).

### Application mailer

This app uses the Action Mailer library in account activation step to verify that 
the user controls the email address they used to sign up.

#### Add SendGrid add-on to Heroku

To send email, this app uses SendGrid, which is available as an add-on at Heroku for verified accounts.
The “starter” tier, which as of this writing is limited to 400 emails a day but costs nothing, 
is the best fit.

Add it to community app as follows:

```
$ heroku addons:create sendgrid:starter
```

#### Define a host variable and change to custom domain

You will also have to define a **host** variable with the address of your production website, 
that can be found under **config/environments/production.rb**. If you use custom domain, please change it too.

```
.
.
host = '<your-heroku-app>.herokuapp.com'
.
.
    .
    :domain         => 'heroku.com',
    .
.
.
```

#### Mailer layout (optional)

Change mailer layout corresponding to the email format.
The HTML and plain-text mailer layouts can be found under **app/views/layouts**

#### Default from address (optional)

Change default **from** address, which is common to all mailers in the application, can be 
found in **app/mailers/application_mailer.rb**

#### Mailer templates (optional)

Change two view templates (if needed) for each mailer, 
one for plain-text email and one for HTML email, found in 
**app/views/user_mailer/account_activation.text.erb** and
**app/views/user_mailer/account_activation.html.erb**

### Picture uploader

This app needs Google Cloud Storage service to store images separately from application.
To store images, this app uses [fog-google](https://github.com/fog/fog-google/blob/master/README.md) 
and google-api-client gems.

#### Google Cloud Platform setup

You have to create a new Google account for this app or use existing account. 
The first step is to [sign up for Google Cloud Platform](https://console.cloud.google.com).

[Add a new project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) 
to your Google Cloud Platform entering a name of your choice, e.g. '**your-heroku-app**'.

Then, [enable billing for your project](https://support.google.com/cloud/answer/6293499#enable-billing) 
and link this billing account to your new project.

#### Google Cloud Storage setup

This app needs a bucket inside your Google Cloud Storage. 
Open the [Cloud Storage browser](https://console.cloud.google.com/storage/) 
in the Google Cloud Platform Console and click **CREATE BUCKET**. 

Setup your bucket as [described](https://cloud.google.com/storage/docs/quickstart-console), e.g. 
with the name **communityapp**.

Turn on [Interoperability API](https://cloud.google.com/storage/docs/migrating#keys) 
for your Google Cloud Platform project and click **Create a new Key** 
to get an **Access Key** and a **Secret**.

#### Heroku config vars setup

Finally, use the Heroku config command to 
[setup config vars](https://devcenter.heroku.com/articles/config-vars) 
for [Google Cloud Storage](https://github.com/carrierwaveuploader/carrierwave#using-google-storage-for-developers) 
using Google's interoperability keys to access it:

```
$ heroku config:set G_STORAGE_ACCESS_KEY=**<your-access-key>**
$ heroku config:set G_STORAGE_SECRET_KEY=**<your-secret>**
$ heroku config:set G_STORAGE_PICTURE_UPLOAD_DIRECTORY=**<your-bucket-name, e.g. 'communityapp'>**
```

Hint: In order to use these [vars in development environment](http://www.rubydoc.info/gems/dotenv-rails/2.2.1), 
you should add them with right values to **.env** file in the root of your project.

### Facebook page posts (optional)

You can use Facebook App to get public posts from some certain public pages 
(e.g. facebook page of your community). 
After that, the most recent posts will be displayed under news feed of your community app.

#### Facebook App setup

Login to [Facebook for Developers](https://developers.facebook.com/apps/) and click 
"Add a New App" in order to create new Facebook App.
Go to Facebook App Settings > Advanced > Security and switch "Require App Secret" to "Yes".

#### Facebook App config vars setup 

Finally, use the Heroku config command to [setup config vars](https://devcenter.heroku.com/articles/config-vars) 
for Facebook App.

```
$ heroku config:set MY_APP_ID=**<your-fb-app-id>**
$ heroku config:set MY_APP_SECRET=**<your-fb-app-secret>**
$ heroku config:set MY_PAGE_ID=**<your-fb-page-id>**
```

You will find the Facebook App ID and Facebook App SECRET on your Facebook App Dashboard.
Use [https://findmyfbid.com/](https://findmyfbid.com/) in order to find facebook page ID of your community.

### Change logo (brand) and generate favicon

Replace **assets/images/logo.png** with a logo of your community. 
Make sure this logo has a **transparent background** and a size of approximately **260x260**.
In order to create a logo you can use [ImageMagick](http://www.imagemagick.org), 
for example with convert command:

```
$ convert big-logo.png -resize 260x260 logo.png
$ convert logo.png -transparent '#ffffff' logo.png
```

You can setup your favicon in your Ruby on Rails project with **rails_real_favicon** gem and/or using 
[Favicon Generator for Ruby on Rails](https://realfavicongenerator.net/favicon/ruby_on_rails).

Your picture should be 260x260 or more for optimal results.

### Change images for introduction carousel

Replace images for carousel items with images of your community 
can be found under **assets/images/introduction/**.
 
Make sure these images have size of **1170x312**, depth of **8 bit** and do **not exceed 200 kb**.
In order to create these images you can use [ImageMagick](https://www.imagemagick.org/Usage/resize/#fill), 
for example with convert command:

```
$ convert item-0.png -resize 1170x312^ -gravity center -extent 1170x312+0-50 item-0.png
$ convert item-0.png -depth 8 item-0.png
$ convert item-0.png -trim -flatten item-0.jpg
```

You can change gravity in any direction, like South or East, and use an offset (e.g. x: +0, y: -50). 

### Deploying to Heroku

Before deploying to Heroku, it’s a good idea to turn maintenance mode on before making the changes:

```
$ heroku maintenance:on
$ git push heroku
$ heroku run rails db:migrate
$ heroku maintenance:off
```

To reset the production database use:

```
$ heroku pg:reset DATABASE
```

After the production database reset, seed the database with start users 
(Rails uses the standard file **db/seeds.rb**):

```
$ heroku run rails db:migrate
$ heroku run rails db:seed
$ heroku restart
```

## Spring processes

Whether  something isn’t behaving as expected, or a process appears to be frozen, 
it’s a good idea to run 

```
$ ps aux | grep spring
```
to see what’s going on, and then run 

```
$ spring stop
```
To kill all the spring processes gunking up your system.

Sometimes this doesn’t work, though, and you can kill all the processes with name spring 
using the pkill command as follows:

```
$ pkill -15 -f spring
```

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).

## RuboCop static code analyzer

Check code with [RuboCop](https://rubocop.readthedocs.io) before committing to Git repository. 
Run in the project directory:

```
$ rubocop -FRE -a
```

## Manage license dependencies

Check dependencies with [license_finder](http://www.rubydoc.info/gems/license_finder), 
detect the licenses and compare those licenses against a whitelist.
Run in the project directory:

```
$ license_finder
```

**license_finder** will inform you whenever you have an unapproved dependency. 
To approve the dependency run e.g.:

```
$ license_finder whitelist add 'MIT' --who '...' --why 'free to use'
```