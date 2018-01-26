# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: ENV['ADMIN_NAME'],
             email: ENV['ADMIN_EMAIL'],
             password: ENV['ADMIN_PASSWORD'],
             password_confirmation: ENV['ADMIN_PASSWORD'],
             admin: true,
             locale: 'en',
             active: true,
             approved: true,
             confirmed: true,
             activated_at: Time.zone.now)

user = User.first
user.posts.create! content: 'This is the first community post!'

# Community introduction and description
Translation.create!([{ key: 'community.name',
                       value: 'Sternfreunde im FEZ e.V.' },
                     { key: 'community.home_page.introduction_html',
                       value: '<p>Wir treffen uns jeden ersten Sonntag im Monat, ab 15 Uhr zu den Vereinssitzungen
                            in unseren <b>Raum 401</b> im <b>%{fez_url}</b> in der <b>Straße zum FEZ 2</b>.
                            Außerdem sind wir bei vielen astronomischen Events in der Region anzutreffen.
                            Wir führen <b>astronomische Beobachtungen</b> in der Nacht durch und
                            machen begeistert <b>Astrofotografie</b>. Über das %{contact_url}
                            kannst Du jederzeit bei uns mitmachen.</p>
                            <p>Wenn Du neugierig geworden bist,
                            dann empfiehlt es sich, einfach unverbindlich vorbeizuschauen.
                            Solltest du dann dem Verein beitreten wollen, findest du hier
                            die %{fee_url}.</p>' },
                     { key: 'community.about_html',
                       value: '<p>Willkommen auf der Homepage des %{community_name}.</p>
                            <p>Wir sind ein %{about_url}
                            in %{directions_url} mit mehr als 35 Jahren Geschichte.
                            Seit Bestehen des Pionierpalastes (Oktober 1979) in der <b>Wuhlheide</b> werden
                            bei uns Kinder und Jugendliche aktiv an die Astronomie herangeführt.</p>' },
                     { key: 'community.short_introduction_html',
                       value: 'Astronomie für Kinder und Jugendliche in Berlin.' },
                     { key: 'community.about_link_html',
                       value: 'gemeinnütziger, astronomischer Verein' },
                     { key: 'community.description_html',
                       value: '<p>Als anerkannter Träger der deutschen Jugendhilfe führen wir die
                        <b>Kinder und Jugendliche</b> aktiv an die Astronomie heran.
                        Wir führen <b>astronomische Beobachtungen</b> in der Nacht durch und
                        machen begeistert <b>Astrofotografie</b>.</p>

                        <p>Wir vermitteln <b>Astronomie, Physik, Informatik und Mathematik</b>,
                        bieten Fernrohre und Fotoausrüstung an, genauso wie
                        Tutorials in der digitalen Bildbearbeitung.</p>' },
                     { key: 'community.about_history_description_html',
                       value: "<p>Seit Bestehen des Pionierpalastes (Oktober 1979) in der Wuhlheide werden bei uns
                          Kinder und Jugendliche aktiv an die Astronomie herangeführt. Vor allem die Sonnenbeobachter
                          können auf eine volle Sonnenperiode zurückschauen.</p>

                          <p>Nach der politischen Wende in der DDR wurde der Pionierpalast umbenannt in
                          Freizeit- und Erholungszentrum Wuhlheide, kurz FEZ. Bis 1995 hatten wir dort immer noch
                          viel Raum für unsere Astronomie. Doch im Rahmen von Stellenabbau und Überführung des FEZ in
                          eine gemeinnützige GmbH wurde die Planstelle Astronomie gestrichen.</p>

                          <p>Um auch weiterhin Astronomie im FEZ anzubieten gab es nur eine Möglichkeit:</p>

                          <p class='text-center'><b>Wir gründen einen Verein!</b></p>

                          <p>Seit dem 24. Juni 1995 sind wir ein Verein. Nach einem langen Briefwechsel mit
                          Amtsgericht und Finanzamt war es Ende 1999 geschafft. Wir dürfen uns jetzt auch
                          Gemeinnützig bezeichnen. Mittlerweile dürfen wir uns auch als anerkannter Träger der
                          deutschen Jugendhilfe bezeichnen.</p>" },
                     { key: 'community.about_membership_html',
                       value: '<p>%{community_name} ist offen für alle Beuscher <b>ab 8 Jahre</b>.
                        Die Mitglieder des Vereins sind <b>Sternfreunde aus Berlin und Brandenburg</b> und
                        wir beteiligen uns an <b>astronomischen Veranstaltungen</b> in der Region.</p>

                        <p>Jetzt den %{membership_application_url} ausfüllen und Mitglied werden!</p>' },
                     { key: 'community.about_membership_application_link_html',
                       value: 'Aufnahmeantrag der %{community_name}' },
                     { key: 'community.about_entrance_fee_html',
                       value: '<p><b>*</b>Alle Beiträge <b>in Euro</b>.</p>' },
                     { key: 'community.about_fee_link_html',
                       value: 'Beitragsinformationen' },
                     { key: 'community.contact_link_html',
                       value: 'Kontaktformular' },
                     { key: 'community.directions_html',
                       value: '<p>%{community_name}</br>
                                  Straße zum FEZ 2</br>
                                  <b>Raum 401</b></br>
                                  12459 Berlin</p>' },
                     { key: 'community.about_directions_html',
                       value: '<p>Gehen Sie in den FEZ-Haupteingang rein, geradeaus die Haupttreppe hoch,
                                in Richtung der Puppenbühne.
                                Rechts daneben befindet sich der Eingang zu uns,
                                <b>zum Raum 401</b> auf dem Dach.</p>' },
                     { key: 'community.directions_link_html',
                       value: '<b>Berlin Treptow-Köpenick</b>' }]) do |translation|
  translation.locale = I18n.default_locale
end

# Community board of directors
Translation.create!([{ key: 'community.about_board_of_directors_chairman_name',
                       value: ENV['ABOUT_BOARD_OF_DIRECTORS_CHAIRMAN_NAME'] },
                     { key: 'community.about_board_of_directors_vice_chairman_name',
                       value: ENV['ABOUT_BOARD_OF_DIRECTORS_VICE_CHAIRMAN_NAME'] },
                     { key: 'community.about_board_of_directors_treasurer_name',
                       value: ENV['ABOUT_BOARD_OF_DIRECTORS_TREASURER_NAME'] }]) do |translation|
  translation.locale = I18n.default_locale
end

if Rails.env.development?
  # Admins
  3.times do |n|
    name = Faker::Name.name
    email = "example-#{n + 1}@railstutorial.org"
    password = 'password'
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 admin: true,
                 locale: 'en',
                 active: true,
                 approved: true,
                 confirmed: true,
                 activated_at: Time.zone.now)
  end

  # Users
  10.times do |n|
    name = Faker::Name.name
    email = "example-#{n + 100}@railstutorial.org"
    password = 'password'
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 locale: 'en',
                 active: true,
                 approved: true,
                 confirmed: true,
                 activated_at: Time.zone.now)
  end

  # Posts by admins
  admins = User.where(admin: true)
  2.times do
    content = Faker::Lorem.sentence(5)
    admins.each { |admin| admin.posts.create!(content: content) }
  end

  # Posts by non admins
  non_admins = User.where(admin: false)
  2.times do
    content = Faker::Lorem.sentence(5)
    non_admins.each { |non_admin| non_admin.posts.create!(content: content) }
  end

  # Following relationships
  non_admins = User.all
  user = non_admins.first
  following = non_admins[2..non_admins.count]
  followers = non_admins[3..non_admins.count - 5]
  following.each { |followed| user.follow(followed) }
  followers.each { |follower| follower.follow(user) }
end
