# OSQDU nginx configuraton generator
nginx (Engine X) web server configuration generator
by OSQDU

## Requirements
The config generator consists of three versions, written in Perl, Ruby and Python. (Only Perl at this time)

### 1. Perl
You'll need a perl intepreter, know how to use CPAN, having make and gcc (probably)

## Command Line Options
static, php, python and rack application: --&lt;server_type&gt; &lt;server_name&gt; &lt;app_root_dir&gt; # create a server block with specified server_type, server_name and application root dir

reverse-proxy application: --proxy &lt;server_name&gt; &lt;backend1&gt; &lt;backend2&gt; &lt;backend3&gt;...

stub-status: --status &lt;server_name&gt; &lt;port%gt;

Available server types:

	static: static web pages

	php: PHP applications

	proxy: reverse-proxy

	rack: Rails, merb, Sinatra and other rack-based application

	python: Python web applications, using WSGI


