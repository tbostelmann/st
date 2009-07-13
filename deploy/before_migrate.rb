run "echo 'release_path: #{release_path}' >> #{shared_path}/logs.log"
run "if [ -d #{release_path} ]; then ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml; fi"