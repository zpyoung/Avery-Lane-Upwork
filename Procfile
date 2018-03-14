release: bin/rails db:migrate

web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb

web: bundle exec puma -C config/puma.rb

worker: bundle exec sidekiq -t 25
