dc=docker-compose -f docker-compose.yml $(1)
dc-run=$(call dc, run --rm web $(1))
dc-exec=$(call dc, exec $(1) $(2))

usage:
	@echo "Available targets:"
	@echo "  * up           		  - Runs the development server"
	@echo "  * sh-web       		  - Fires a sh shell inside your container"
	@echo "  * restart      		  - Restart the development server"
	@echo "  * rebuild      		  - Rebuild all containers and restart the development server"
	@echo "  * stop         		  - Stops the server"
	@echo "  * down         		  - Removes all the containers and tears down the setup"
	@echo "  * bundle       		  - Install missing gems"
	@echo "  * console      		  - Runs rails console"
	@echo "  * db-migrate   		  - Runs the migrations for dev database"
	@echo "  * db-seed      		  - Seeds the database"
	@echo "  * logs         		  - Displays logs of all containers"
	@echo "  * logs-web     		  - Displays logs of web application"
	@echo "  * test         		  - Runs tests"
	@echo "  * test-coverage		  - Runs tests with coverage"

# docker-compose
up:
	$(call dc, up -d web)
sh-web:
	$(call dc-exec, web, sh)
restart: stop up
rebuild: down up
stop:
	$(call dc, stop)
down:
	$(call dc, down --remove-orphans)

# Rails
bundle:
	$(call dc-run, bundle install)
console:
	$(call dc-run, rails console)
console-sandbox:
	$(call dc-run, rails console --sandbox)
rails-cache-clear:
	$(call dc-run, rails r 'Rails.cache.clear')
guard:
	$(call dc-run, guard)

# Database
db-create:
	$(call dc, up -d postgres)
	$(call dc-run, rails db:create)
db-migrate:
	$(call dc-run, rails db:migrate)
db-seed:
	$(call dc-run, rails db:seed)
db-drop:
	$(call dc-run, rails db:drop)

# logs
logs:
	$(call dc, logs -tf)
logs-web:
	$(call dc, logs -tf web)

# Tests
.PHONY: test
test:
	$(call dc-run, rails test)
test-coverage:
	$(call dc-run, rails test COVERAGE=true)
