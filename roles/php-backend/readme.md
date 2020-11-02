# PHP Backend
This role is meant to deploy `php-fpm` to work with Nginx

## Variables
This role needs a few information to execute properly
```ansible
username: SSL username
pb_server_name: server name requirering php backend
```
By default, the PHP version is set to `7.3` supported by 
`Debian 10`:
```ansible
php_default_version: "7.3"
```

## Template
The template is an updated version of the template used by the
`static-website` role:
```jinja2
location / {
  # try_files $uri $uri/ /index.php$request_uri /index.html;
	#                ^ here is the problem
	# issue solved here :
	# This is caused because nginx will try to index the directory
  # and be blocked by itself. Throwing the error mentioned by OP
	# https://stackoverflow.com/questions/19285355/nginx-403-error-directory-index-of-folder-is-forbidden
	# also documented here : https://stackoverflow.com/a/51266372/4166732
	
  try_files $uri /index.php$is_args$args;
}

location ~* \.php$ {
  try_files      $uri =404;
  
  fastcgi_pass   127.0.0.1:9000;
  fastcgi_index  index.php;
  fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
  include        fastcgi_params;
}
```

### Templating issue
As seen above, I encountered a situation where I had the following error message
`directory index of [] is forbidden`.

I found that the problem was both that the `fastcgi` was not sufficiently served 
in the php location and that the `index` instruction made it so that nginx would 
index the directory before executing php script.
