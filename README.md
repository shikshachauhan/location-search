# location-search

This application provides a tool for suggesting a location based on a start destination and keywords

Steps to run(Assuming a Linux OS)

1. Install ruby
`https://www.digitalocean.com/community/tutorials/how-to-install-ruby-and-set-up-a-local-programming-environment-on-ubuntu-16-04`

2. Intall Elastic Search
`https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-14-04`

3. Install Redis
`https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis`

4. Install libraries required
    `gem install redis
    gem install net/http
    gem install uri
    gem install json
    gem install timeout`

5. Clone this repository

    `git clone https://github.com/shikshachauhan/location-search.git`

6. Checkout to this directory
    `cd location-search`

7. Initialize Application
    `ruby lib/initializer.rb`

8. Run application
    `ruby main.rb`


# Test cases

1. Intall dependent library
    `gem install minitest`

2. Checkout to this directory
    `cd location-search`

3. Run command
    `ruby test/test_runner.rb`
