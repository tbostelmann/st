run "echo 'release_path: #{release_path}' >> #{shared_path}/logs.log"
run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"