# OSQDU nginx configuraton generator
nginx (Engine X) web server configuration generator
by OSQDU

## Requirements
The config generator consists of three versions, written in Perl, Ruby and Python. (Only Perl at this time)

### 1. Perl
You'll need a perl intepreter, know how to use CPAN, having make and gcc (probably)

## Command Line Options
static, php, python and rack application: --<server_type> <server_name> <app_root_dir> # create a server block with specified server_type, server_name and application root dir

reverse-proxy application: --proxy <server_name> <backend1> <backend2> <backend3>...

stub-status: --status <server_name> <port>

Available server types:
	static: static web pages
	php: PHP applications
	proxy: reverse-proxy
	rack: Rails, merb, Sinatra and other rack-based application
	python: Python web applications, using WSGI


