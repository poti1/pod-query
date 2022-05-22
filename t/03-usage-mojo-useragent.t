#!perl
use v5.16;
use strict;
use warnings;
use Test::More;

#TODO: Remove this debug code !!!
use feature qw(say);
use Mojo::Util qw(dumper);

BEGIN {
   use_ok( 'Pod::Query' ) || print "Bail out!\n";
}

diag( "Testing Pod::Query $Pod::Query::VERSION, Perl $], $^X" );

my $class_dir = "dir";
my $class     = "MyClass1";

my @cases = (
   {
      name      => "Mojo::UserAgent",
      pod_class => $class,
      lol       => [
         [ "head1", "NAME" ],
         [
            "Para",
            "Mojo::UserAgent - Non-blocking I/O HTTP and WebSocket user agent"
         ],
         [ "head1", "SYNOPSIS" ],
         [
            "Verbatim",
"  use Mojo::UserAgent;\n\n  # Fine grained response handling (dies on connection errors)\n  my \$ua  = Mojo::UserAgent->new;\n  my \$res = \$ua->get('docs.mojolicious.org')->result;\n  if    (\$res->is_success)  { say \$res->body }\n  elsif (\$res->is_error)    { say \$res->message }\n  elsif (\$res->code == 301) { say \$res->headers->location }\n  else                      { say 'Whatever...' }\n\n  # Say hello to the Unicode snowman and include an Accept header\n  say \$ua->get('www.\x{2603}.net?hello=there' => {Accept => '*/*'})->result->body;\n\n  # Extract data from HTML and XML resources with CSS selectors\n  say \$ua->get('www.perl.org')->result->dom->at('title')->text;\n\n  # Scrape the latest headlines from a news site\n  say \$ua->get('blogs.perl.org')->result->dom->find('h2 > a')->map('text')->join(\"\\n\");\n\n  # IPv6 PUT request with Content-Type header and content\n  my \$tx = \$ua->put('[::1]:3000' => {'Content-Type' => 'text/plain'} => 'Hi!');\n\n  # Quick JSON API request with Basic authentication\n  my \$url = Mojo::URL->new('https://example.com/test.json')->userinfo('sri:\x{2603}');\n  my \$value = \$ua->get(\$url)->result->json;\n\n  # JSON POST (application/json) with TLS certificate authentication\n  my \$tx = \$ua->cert('tls.crt')->key('tls.key')->post('https://example.com' => json => {top => 'secret'});\n\n  # Form POST (application/x-www-form-urlencoded)\n  my \$tx = \$ua->post('https://metacpan.org/search' => form => {q => 'mojo'});\n\n  # Search DuckDuckGo anonymously through Tor\n  \$ua->proxy->http('socks://127.0.0.1:9050');\n  say \$ua->get('api.3g2upl4pq6kufc4m.onion/?q=mojolicious&format=json')->result->json('/Abstract');\n\n  # GET request via UNIX domain socket \"/tmp/myapp.sock\" (percent encoded slash)\n  say \$ua->get('http+unix://%2Ftmp%2Fmyapp.sock/test')->result->body;\n\n  # Follow redirects to download Mojolicious from GitHub\n  \$ua->max_redirects(5)\n    ->get('https://www.github.com/mojolicious/mojo/tarball/main')\n    ->result->save_to('/home/sri/mojo.tar.gz');\n\n  # Non-blocking request\n  \$ua->get('mojolicious.org' => sub (\$ua, \$tx) { say \$tx->result->dom->at('title')->text });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;\n\n  # Concurrent non-blocking requests (synchronized with promises)\n  my \$mojo_promise = \$ua->get_p('mojolicious.org');\n  my \$cpan_promise = \$ua->get_p('cpan.org');\n  Mojo::Promise->all(\$mojo_promise, \$cpan_promise)->then(sub (\$mojo, \$cpan) {\n    say \$mojo->[0]->result->dom->at('title')->text;\n    say \$cpan->[0]->result->dom->at('title')->text;\n  })->wait;\n\n  # WebSocket connection sending and receiving JSON via UNIX domain socket\n  \$ua->websocket('ws+unix://%2Ftmp%2Fmyapp.sock/echo.json' => sub (\$ua, \$tx) {\n    say 'WebSocket handshake failed!' and return unless \$tx->is_websocket;\n    \$tx->on(json => sub (\$tx, \$hash) {\n      say \"WebSocket message via JSON: \$hash->{msg}\";\n      \$tx->finish;\n    });\n    \$tx->send({json => {msg => 'Hello World!'}});\n  });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head1", "DESCRIPTION" ],
         [
            "Para",
"Mojo::UserAgent is a full featured non-blocking I/O HTTP and WebSocket user agent, with IPv6, TLS, SNI, IDNA, HTTP/SOCKS5 proxy, UNIX domain socket, Comet (long polling), Promises/A+, keep-alive, connection pooling, timeout, cookie, multipart, gzip compression and multiple event loop support."
         ],
         [
            "Para",
"All connections will be reset automatically if a new process has been forked, this allows multiple processes to share the same Mojo::UserAgent object safely."
         ],
         [
            "Para",
"For better scalability (epoll, kqueue) and to provide non-blocking name resolution, SOCKS5 as well as TLS support, the optional modules EV (4.32+), Net::DNS::Native (0.15+), IO::Socket::Socks (0.64+) and IO::Socket::SSL (2.009+) will be used automatically if possible. Individual features can also be disabled with the MOJO_NO_NNR, MOJO_NO_SOCKS and MOJO_NO_TLS environment variables."
         ],
         [
            "Para",
            "See \"USER AGENT\" in Mojolicious::Guides::Cookbook for more."
         ],
         [ "head1", "EVENTS" ],
         [
            "Para",
"Mojo::UserAgent inherits all events from Mojo::EventEmitter and can emit the following new ones."
         ],
         [ "head2",    "prepare" ],
         [ "Verbatim", "  \$ua->on(prepare => sub (\$ua, \$tx) {...});" ],
         [
            "Para",
"Emitted whenever a new transaction is being prepared, before relative URLs are rewritten and cookies added. This includes automatically prepared proxy CONNECT requests and followed redirects."
         ],
         [
            "Verbatim",
"  \$ua->on(prepare => sub (\$ua, \$tx) {\n    \$tx->req->url(Mojo::URL->new('/mock-mojolicious')) if \$tx->req->url->host eq 'mojolicious.org';\n  });"
         ],
         [ "head2",    "start" ],
         [ "Verbatim", "  \$ua->on(start => sub (\$ua, \$tx) {...});" ],
         [
            "Para",
"Emitted whenever a new transaction is about to start. This includes automatically prepared proxy CONNECT requests and followed redirects."
         ],
         [
            "Verbatim",
"  \$ua->on(start => sub (\$ua, \$tx) {\n    \$tx->req->headers->header('X-Bender' => 'Bite my shiny metal ass!');\n  });"
         ],
         [ "head1", "ATTRIBUTES" ],
         [ "Para",  "Mojo::UserAgent implements the following attributes." ],
         [ "head2", "ca" ],
         [
            "Verbatim",
            "  my \$ca = \$ua->ca;\n  \$ua    = \$ua->ca('/etc/tls/ca.crt');"
         ],
         [
            "Para",
"Path to TLS certificate authority file used to verify the peer certificate, defaults to the value of the MOJO_CA_FILE environment variable."
         ],
         [
            "Verbatim",
"  # Show certificate authorities for debugging\n  IO::Socket::SSL::set_defaults(SSL_verify_callback => sub { say \"Authority: \$_[2]\" and return \$_[0] });"
         ],
         [ "head2", "cert" ],
         [
            "Verbatim",
"  my \$cert = \$ua->cert;\n  \$ua      = \$ua->cert('/etc/tls/client.crt');"
         ],
         [
            "Para",
"Path to TLS certificate file, defaults to the value of the MOJO_CERT_FILE environment variable."
         ],
         [ "head2", "connect_timeout" ],
         [
            "Verbatim",
"  my \$timeout = \$ua->connect_timeout;\n  \$ua         = \$ua->connect_timeout(5);"
         ],
         [
            "Para",
"Maximum amount of time in seconds establishing a connection may take before getting canceled, defaults to the value of the MOJO_CONNECT_TIMEOUT environment variable or 10."
         ],
         [ "head2", "cookie_jar" ],
         [
            "Verbatim",
"  my \$cookie_jar = \$ua->cookie_jar;\n  \$ua            = \$ua->cookie_jar(Mojo::UserAgent::CookieJar->new);"
         ],
         [
            "Para",
"Cookie jar to use for requests performed by this user agent, defaults to a Mojo::UserAgent::CookieJar object."
         ],
         [
            "Verbatim",
"  # Ignore all cookies\n  \$ua->cookie_jar->ignore(sub { 1 });\n\n  # Ignore cookies for public suffixes\n  my \$ps = IO::Socket::SSL::PublicSuffix->default;\n  \$ua->cookie_jar->ignore(sub (\$cookie) {\n    return undef unless my \$domain = \$cookie->domain;\n    return (\$ps->public_suffix(\$domain))[0] eq '';\n  });\n\n  # Add custom cookie to the jar\n  \$ua->cookie_jar->add(\n    Mojo::Cookie::Response->new(\n      name   => 'foo',\n      value  => 'bar',\n      domain => 'docs.mojolicious.org',\n      path   => '/Mojolicious'\n    )\n  );"
         ],
         [ "head2", "inactivity_timeout" ],
         [
            "Verbatim",
"  my \$timeout = \$ua->inactivity_timeout;\n  \$ua         = \$ua->inactivity_timeout(15);"
         ],
         [
            "Para",
"Maximum amount of time in seconds a connection can be inactive before getting closed, defaults to the value of the MOJO_INACTIVITY_TIMEOUT environment variable or 40. Setting the value to 0 will allow connections to be inactive indefinitely."
         ],
         [ "head2", "insecure" ],
         [
            "Verbatim",
"  my \$bool = \$ua->insecure;\n  \$ua      = \$ua->insecure(\$bool);"
         ],
         [
            "Para",
"Do not require a valid TLS certificate to access HTTPS/WSS sites, defaults to the value of the MOJO_INSECURE environment variable."
         ],
         [
            "Verbatim",
"  # Disable TLS certificate verification for testing\n  say \$ua->insecure(1)->get('https://127.0.0.1:3000')->result->code;"
         ],
         [ "head2", "ioloop" ],
         [
            "Verbatim",
"  my \$loop = \$ua->ioloop;\n  \$ua      = \$ua->ioloop(Mojo::IOLoop->new);"
         ],
         [
            "Para",
"Event loop object to use for blocking I/O operations, defaults to a Mojo::IOLoop object."
         ],
         [ "head2", "key" ],
         [
            "Verbatim",
"  my \$key = \$ua->key;\n  \$ua     = \$ua->key('/etc/tls/client.crt');"
         ],
         [
            "Para",
"Path to TLS key file, defaults to the value of the MOJO_KEY_FILE environment variable."
         ],
         [ "head2", "max_connections" ],
         [
            "Verbatim",
"  my \$max = \$ua->max_connections;\n  \$ua     = \$ua->max_connections(5);"
         ],
         [
            "Para",
"Maximum number of keep-alive connections that the user agent will retain before it starts closing the oldest ones, defaults to 5. Setting the value to 0 will prevent any connections from being kept alive."
         ],
         [ "head2", "max_redirects" ],
         [
            "Verbatim",
"  my \$max = \$ua->max_redirects;\n  \$ua     = \$ua->max_redirects(3);"
         ],
         [
            "Para",
"Maximum number of redirects the user agent will follow before it fails, defaults to the value of the MOJO_MAX_REDIRECTS environment variable or 0."
         ],
         [ "head2", "max_response_size" ],
         [
            "Verbatim",
"  my \$max = \$ua->max_response_size;\n  \$ua     = \$ua->max_response_size(16777216);"
         ],
         [
            "Para",
"Maximum response size in bytes, defaults to the value of \"max_message_size\" in Mojo::Message::Response. Setting the value to 0 will allow responses of indefinite size. Note that increasing this value can also drastically increase memory usage, should you for example attempt to parse an excessively large response body with the methods \"dom\" in Mojo::Message or \"json\" in Mojo::Message."
         ],
         [ "head2", "proxy" ],
         [
            "Verbatim",
"  my \$proxy = \$ua->proxy;\n  \$ua       = \$ua->proxy(Mojo::UserAgent::Proxy->new);"
         ],
         [
            "Para",
            "Proxy manager, defaults to a Mojo::UserAgent::Proxy object."
         ],
         [
            "Verbatim",
"  # Detect proxy servers from environment\n  \$ua->proxy->detect;\n\n  # Manually configure HTTP proxy (using CONNECT for HTTPS/WebSockets)\n  \$ua->proxy->http('http://127.0.0.1:8080')->https('http://127.0.0.1:8080');\n\n  # Manually configure Tor (SOCKS5)\n  \$ua->proxy->http('socks://127.0.0.1:9050')->https('socks://127.0.0.1:9050');\n\n  # Manually configure UNIX domain socket (using CONNECT for HTTPS/WebSockets)\n  \$ua->proxy->http('http+unix://%2Ftmp%2Fproxy.sock') ->https('http+unix://%2Ftmp%2Fproxy.sock');"
         ],
         [ "head2", "request_timeout" ],
         [
            "Verbatim",
"  my \$timeout = \$ua->request_timeout;\n  \$ua         = \$ua->request_timeout(5);"
         ],
         [
            "Para",
"Maximum amount of time in seconds establishing a connection, sending the request and receiving a whole response may take before getting canceled, defaults to the value of the MOJO_REQUEST_TIMEOUT environment variable or 0. Setting the value to 0 will allow the user agent to wait indefinitely. The timeout will reset for every followed redirect."
         ],
         [
            "Verbatim",
"  # Total limit of 5 seconds, of which 3 seconds may be spent connecting\n  \$ua->max_redirects(0)->connect_timeout(3)->request_timeout(5);"
         ],
         [ "head2", "server" ],
         [
            "Verbatim",
"  my \$server = \$ua->server;\n  \$ua        = \$ua->server(Mojo::UserAgent::Server->new);"
         ],
         [
            "Para",
"Application server relative URLs will be processed with, defaults to a Mojo::UserAgent::Server object."
         ],
         [
            "Verbatim",
"  # Mock web service\n  \$ua->server->app(Mojolicious->new);\n  \$ua->server->app->routes->get('/time' => sub (\$c) {\n    \$c->render(json => {now => time});\n  });\n  my \$time = \$ua->get('/time')->result->json->{now};\n\n  # Change log level\n  \$ua->server->app->log->level('fatal');\n\n  # Port currently used for processing relative URLs blocking\n  say \$ua->server->url->port;\n\n  # Port currently used for processing relative URLs non-blocking\n  say \$ua->server->nb_url->port;"
         ],
         [ "head2", "socket_options" ],
         [
            "Verbatim",
"  my \$options = \$ua->socket_options;\n  \$ua         = \$ua->socket_options({LocalAddr => '127.0.0.1'});"
         ],
         [
            "Para",
"Additional options for IO::Socket::IP when opening new connections."
         ],
         [ "head2", "transactor" ],
         [
            "Verbatim",
"  my \$t = \$ua->transactor;\n  \$ua   = \$ua->transactor(Mojo::UserAgent::Transactor->new);"
         ],
         [
            "Para",
"Transaction builder, defaults to a Mojo::UserAgent::Transactor object."
         ],
         [
            "Verbatim",
"  # Change name of user agent\n  \$ua->transactor->name('MyUA 1.0');\n\n  # Disable compression\n  \$ua->transactor->compressed(0);"
         ],
         [ "head1", "METHODS" ],
         [
            "Para",
"Mojo::UserAgent inherits all methods from Mojo::EventEmitter and implements the following new ones."
         ],
         [ "head2", "build_tx" ],
         [
            "Verbatim",
"  my \$tx = \$ua->build_tx(GET => 'example.com');\n  my \$tx = \$ua->build_tx(PUT => 'http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->build_tx(PUT => 'http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->build_tx(PUT => 'http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Generate Mojo::Transaction::HTTP object with \"tx\" in Mojo::UserAgent::Transactor."
         ],
         [
            "Verbatim",
"  # Request with custom cookie\n  my \$tx = \$ua->build_tx(GET => 'https://example.com/account');\n  \$tx->req->cookies({name => 'user', value => 'sri'});\n  \$tx = \$ua->start(\$tx);\n\n  # Deactivate gzip compression\n  my \$tx = \$ua->build_tx(GET => 'example.com');\n  \$tx->req->headers->remove('Accept-Encoding');\n  \$tx = \$ua->start(\$tx);\n\n  # Interrupt response by raising an error\n  my \$tx = \$ua->build_tx(GET => 'http://example.com');\n  \$tx->res->on(progress => sub (\$res) {\n    return unless my \$server = \$res->headers->server;\n    \$res->error({message => 'Oh noes, it is IIS!'}) if \$server =~ /IIS/;\n  });\n  \$tx = \$ua->start(\$tx);"
         ],
         [ "head2", "build_websocket_tx" ],
         [
            "Verbatim",
"  my \$tx = \$ua->build_websocket_tx('ws://example.com');\n  my \$tx = \$ua->build_websocket_tx( 'ws://example.com' => {DNT => 1} => ['v1.proto']);"
         ],
         [
            "Para",
"Generate Mojo::Transaction::HTTP object with \"websocket\" in Mojo::UserAgent::Transactor."
         ],
         [
            "Verbatim",
"  # Custom WebSocket handshake with cookie\n  my \$tx = \$ua->build_websocket_tx('wss://example.com/echo');\n  \$tx->req->cookies({name => 'user', value => 'sri'});\n  \$ua->start(\$tx => sub (\$ua, \$tx) {\n    say 'WebSocket handshake failed!' and return unless \$tx->is_websocket;\n    \$tx->on(message => sub (\$tx, \$msg) {\n      say \"WebSocket message: \$msg\";\n      \$tx->finish;\n    });\n    \$tx->send('Hi!');\n  });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2", "delete" ],
         [
            "Verbatim",
"  my \$tx = \$ua->delete('example.com');\n  my \$tx = \$ua->delete('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->delete('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->delete('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform blocking DELETE request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the DELETE method, which is implied). You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  \$ua->delete('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2", "delete_p" ],
         [
            "Verbatim",
            "  my \$promise = \$ua->delete_p('http://example.com');"
         ],
         [
            "Para",
"Same as \"delete\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->delete_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "get" ],
         [
            "Verbatim",
"  my \$tx = \$ua->get('example.com');\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform blocking GET request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the GET method, which is implied). You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  \$ua->get('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2",    "get_p" ],
         [ "Verbatim", "  my \$promise = \$ua->get_p('http://example.com');" ],
         [
            "Para",
"Same as \"get\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->get_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "head" ],
         [
            "Verbatim",
"  my \$tx = \$ua->head('example.com');\n  my \$tx = \$ua->head('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->head('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->head('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform blocking HEAD request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the HEAD method, which is implied). You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  \$ua->head('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2",    "head_p" ],
         [ "Verbatim", "  my \$promise = \$ua->head_p('http://example.com');" ],
         [
            "Para",
"Same as \"head\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->head_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "options" ],
         [
            "Verbatim",
"  my \$tx = \$ua->options('example.com');\n  my \$tx = \$ua->options('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->options('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->options('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform blocking OPTIONS request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the OPTIONS method, which is implied). You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  \$ua->options('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2", "options_p" ],
         [
            "Verbatim",
            "  my \$promise = \$ua->options_p('http://example.com');"
         ],
         [
            "Para",
"Same as \"options\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->options_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "patch" ],
         [
            "Verbatim",
"  my \$tx = \$ua->patch('example.com');\n  my \$tx = \$ua->patch('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->patch('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->patch('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform blocking PATCH request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the PATCH method, which is implied). You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  \$ua->patch('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2", "patch_p" ],
         [
            "Verbatim", "  my \$promise = \$ua->patch_p('http://example.com');"
         ],
         [
            "Para",
"Same as \"patch\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->patch_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "post" ],
         [
            "Verbatim",
"  my \$tx = \$ua->post('example.com');\n  my \$tx = \$ua->post('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->post('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->post('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform blocking POST request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the POST method, which is implied). You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  \$ua->post('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2",    "post_p" ],
         [ "Verbatim", "  my \$promise = \$ua->post_p('http://example.com');" ],
         [
            "Para",
"Same as \"post\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->post_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "put" ],
         [
            "Verbatim",
"  my \$tx = \$ua->put('example.com');\n  my \$tx = \$ua->put('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->put('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->put('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform blocking PUT request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the PUT method, which is implied). You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  \$ua->put('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2",    "put_p" ],
         [ "Verbatim", "  my \$promise = \$ua->put_p('http://example.com');" ],
         [
            "Para",
"Same as \"put\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->put_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "start" ],
         [
            "Verbatim",
            "  my \$tx = \$ua->start(Mojo::Transaction::HTTP->new);"
         ],
         [
            "Para",
"Perform blocking request for a custom Mojo::Transaction::HTTP object, which can be prepared manually or with \"build_tx\". You can also append a callback to perform requests non-blocking."
         ],
         [
            "Verbatim",
"  my \$tx = \$ua->build_tx(GET => 'http://example.com');\n  \$ua->start(\$tx => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [ "head2", "start_p" ],
         [
            "Verbatim",
            "  my \$promise = \$ua->start_p(Mojo::Transaction::HTTP->new);"
         ],
         [
            "Para",
"Same as \"start\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  my \$tx = \$ua->build_tx(GET => 'http://example.com');\n  \$ua->start_p(\$tx)->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
         ],
         [ "head2", "websocket" ],
         [
            "Verbatim",
"  \$ua->websocket('ws://example.com' => sub {...});\n  \$ua->websocket('ws://example.com' => {DNT => 1} => ['v1.proto'] => sub {...});"
         ],
         [
            "Para",
"Open a non-blocking WebSocket connection with transparent handshake, takes the same arguments as \"websocket\" in Mojo::UserAgent::Transactor. The callback will receive either a Mojo::Transaction::WebSocket or Mojo::Transaction::HTTP object, depending on if the handshake was successful."
         ],
         [
            "Verbatim",
"  \$ua->websocket('wss://example.com/echo' => ['v1.proto'] => sub (\$ua, \$tx) {\n    say 'WebSocket handshake failed!' and return unless \$tx->is_websocket;\n    say 'Subprotocol negotiation failed!' and return unless \$tx->protocol;\n    \$tx->on(finish => sub (\$tx, \$code, \$reason) { say \"WebSocket closed with status \$code.\" });\n    \$tx->on(message => sub (\$tx, \$msg) {\n      say \"WebSocket message: \$msg\";\n      \$tx->finish;\n    });\n    \$tx->send('Hi!');\n  });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
         ],
         [
            "Para",
"You can activate permessage-deflate compression by setting the Sec-WebSocket-Extensions header, this can result in much better performance, but also increases memory usage by up to 300KiB per connection."
         ],
         [
            "Verbatim",
"  \$ua->websocket('ws://example.com/foo' => {\n    'Sec-WebSocket-Extensions' => 'permessage-deflate'\n  } => sub {...});"
         ],
         [ "head2", "websocket_p" ],
         [
            "Verbatim",
            "  my \$promise = \$ua->websocket_p('ws://example.com');"
         ],
         [
            "Para",
"Same as \"websocket\", but returns a Mojo::Promise object instead of accepting a callback."
         ],
         [
            "Verbatim",
"  \$ua->websocket_p('wss://example.com/echo')->then(sub (\$tx) {\n    my \$promise = Mojo::Promise->new;\n    \$tx->on(finish => sub { \$promise->resolve });\n    \$tx->on(message => sub (\$tx, \$msg) {\n      say \"WebSocket message: \$msg\";\n      \$tx->finish;\n    });\n    \$tx->send('Hi!');\n    return \$promise;\n  })->catch(sub (\$err) {\n    warn \"WebSocket error: \$err\";\n  })->wait;"
         ],
         [ "head1", "DEBUGGING" ],
         [
            "Para",
"You can set the MOJO_CLIENT_DEBUG environment variable to get some advanced diagnostics information printed to STDERR."
         ],
         [ "Verbatim", "  MOJO_CLIENT_DEBUG=1" ],
         [ "head1",    "SEE ALSO" ],
         [
            "Para",
            "Mojolicious, Mojolicious::Guides, https://mojolicious.org."
         ]
      ],
      expected_tree => [
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"Mojo::UserAgent - Non-blocking I/O HTTP and WebSocket user agent"
                  ]
               }
            ],
            "tag"  => "head1",
            "text" => ["NAME"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Verbatim",
                  "text" => [
"  use Mojo::UserAgent;\n\n  # Fine grained response handling (dies on connection errors)\n  my \$ua  = Mojo::UserAgent->new;\n  my \$res = \$ua->get('docs.mojolicious.org')->result;\n  if    (\$res->is_success)  { say \$res->body }\n  elsif (\$res->is_error)    { say \$res->message }\n  elsif (\$res->code == 301) { say \$res->headers->location }\n  else                      { say 'Whatever...' }\n\n  # Say hello to the Unicode snowman and include an Accept header\n  say \$ua->get('www.\x{2603}.net?hello=there' => {Accept => '*/*'})->result->body;\n\n  # Extract data from HTML and XML resources with CSS selectors\n  say \$ua->get('www.perl.org')->result->dom->at('title')->text;\n\n  # Scrape the latest headlines from a news site\n  say \$ua->get('blogs.perl.org')->result->dom->find('h2 > a')->map('text')->join(\"\\n\");\n\n  # IPv6 PUT request with Content-Type header and content\n  my \$tx = \$ua->put('[::1]:3000' => {'Content-Type' => 'text/plain'} => 'Hi!');\n\n  # Quick JSON API request with Basic authentication\n  my \$url = Mojo::URL->new('https://example.com/test.json')->userinfo('sri:\x{2603}');\n  my \$value = \$ua->get(\$url)->result->json;\n\n  # JSON POST (application/json) with TLS certificate authentication\n  my \$tx = \$ua->cert('tls.crt')->key('tls.key')->post('https://example.com' => json => {top => 'secret'});\n\n  # Form POST (application/x-www-form-urlencoded)\n  my \$tx = \$ua->post('https://metacpan.org/search' => form => {q => 'mojo'});\n\n  # Search DuckDuckGo anonymously through Tor\n  \$ua->proxy->http('socks://127.0.0.1:9050');\n  say \$ua->get('api.3g2upl4pq6kufc4m.onion/?q=mojolicious&format=json')->result->json('/Abstract');\n\n  # GET request via UNIX domain socket \"/tmp/myapp.sock\" (percent encoded slash)\n  say \$ua->get('http+unix://%2Ftmp%2Fmyapp.sock/test')->result->body;\n\n  # Follow redirects to download Mojolicious from GitHub\n  \$ua->max_redirects(5)\n    ->get('https://www.github.com/mojolicious/mojo/tarball/main')\n    ->result->save_to('/home/sri/mojo.tar.gz');\n\n  # Non-blocking request\n  \$ua->get('mojolicious.org' => sub (\$ua, \$tx) { say \$tx->result->dom->at('title')->text });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;\n\n  # Concurrent non-blocking requests (synchronized with promises)\n  my \$mojo_promise = \$ua->get_p('mojolicious.org');\n  my \$cpan_promise = \$ua->get_p('cpan.org');\n  Mojo::Promise->all(\$mojo_promise, \$cpan_promise)->then(sub (\$mojo, \$cpan) {\n    say \$mojo->[0]->result->dom->at('title')->text;\n    say \$cpan->[0]->result->dom->at('title')->text;\n  })->wait;\n\n  # WebSocket connection sending and receiving JSON via UNIX domain socket\n  \$ua->websocket('ws+unix://%2Ftmp%2Fmyapp.sock/echo.json' => sub (\$ua, \$tx) {\n    say 'WebSocket handshake failed!' and return unless \$tx->is_websocket;\n    \$tx->on(json => sub (\$tx, \$hash) {\n      say \"WebSocket message via JSON: \$hash->{msg}\";\n      \$tx->finish;\n    });\n    \$tx->send({json => {msg => 'Hello World!'}});\n  });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                  ]
               }
            ],
            "tag"  => "head1",
            "text" => ["SYNOPSIS"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"Mojo::UserAgent is a full featured non-blocking I/O HTTP and WebSocket user agent, with IPv6, TLS, SNI, IDNA, HTTP/SOCKS5 proxy, UNIX domain socket, Comet (long polling), Promises/A+, keep-alive, connection pooling, timeout, cookie, multipart, gzip compression and multiple event loop support."
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"All connections will be reset automatically if a new process has been forked, this allows multiple processes to share the same Mojo::UserAgent object safely."
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"For better scalability (epoll, kqueue) and to provide non-blocking name resolution, SOCKS5 as well as TLS support, the optional modules EV (4.32+), Net::DNS::Native (0.15+), IO::Socket::Socks (0.64+) and IO::Socket::SSL (2.009+) will be used automatically if possible. Individual features can also be disabled with the MOJO_NO_NNR, MOJO_NO_SOCKS and MOJO_NO_TLS environment variables."
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"See \"USER AGENT\" in Mojolicious::Guides::Cookbook for more."
                  ]
               }
            ],
            "tag"  => "head1",
            "text" => ["DESCRIPTION"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"Mojo::UserAgent inherits all events from Mojo::EventEmitter and can emit the following new ones."
                  ]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" =>
                          ["  \$ua->on(prepare => sub (\$ua, \$tx) {...});"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Emitted whenever a new transaction is being prepared, before relative URLs are rewritten and cookies added. This includes automatically prepared proxy CONNECT requests and followed redirects."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->on(prepare => sub (\$ua, \$tx) {\n    \$tx->req->url(Mojo::URL->new('/mock-mojolicious')) if \$tx->req->url->host eq 'mojolicious.org';\n  });"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["prepare"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" =>
                          ["  \$ua->on(start => sub (\$ua, \$tx) {...});"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Emitted whenever a new transaction is about to start. This includes automatically prepared proxy CONNECT requests and followed redirects."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->on(start => sub (\$ua, \$tx) {\n    \$tx->req->headers->header('X-Bender' => 'Bite my shiny metal ass!');\n  });"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["start"]
               }
            ],
            "tag"  => "head1",
            "text" => ["EVENTS"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" =>
                    ["Mojo::UserAgent implements the following attributes."]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$ca = \$ua->ca;\n  \$ua    = \$ua->ca('/etc/tls/ca.crt');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Path to TLS certificate authority file used to verify the peer certificate, defaults to the value of the MOJO_CA_FILE environment variable."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Show certificate authorities for debugging\n  IO::Socket::SSL::set_defaults(SSL_verify_callback => sub { say \"Authority: \$_[2]\" and return \$_[0] });"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["ca"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$cert = \$ua->cert;\n  \$ua      = \$ua->cert('/etc/tls/client.crt');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Path to TLS certificate file, defaults to the value of the MOJO_CERT_FILE environment variable."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["cert"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$timeout = \$ua->connect_timeout;\n  \$ua         = \$ua->connect_timeout(5);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Maximum amount of time in seconds establishing a connection may take before getting canceled, defaults to the value of the MOJO_CONNECT_TIMEOUT environment variable or 10."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["connect_timeout"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$cookie_jar = \$ua->cookie_jar;\n  \$ua            = \$ua->cookie_jar(Mojo::UserAgent::CookieJar->new);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Cookie jar to use for requests performed by this user agent, defaults to a Mojo::UserAgent::CookieJar object."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Ignore all cookies\n  \$ua->cookie_jar->ignore(sub { 1 });\n\n  # Ignore cookies for public suffixes\n  my \$ps = IO::Socket::SSL::PublicSuffix->default;\n  \$ua->cookie_jar->ignore(sub (\$cookie) {\n    return undef unless my \$domain = \$cookie->domain;\n    return (\$ps->public_suffix(\$domain))[0] eq '';\n  });\n\n  # Add custom cookie to the jar\n  \$ua->cookie_jar->add(\n    Mojo::Cookie::Response->new(\n      name   => 'foo',\n      value  => 'bar',\n      domain => 'docs.mojolicious.org',\n      path   => '/Mojolicious'\n    )\n  );"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["cookie_jar"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$timeout = \$ua->inactivity_timeout;\n  \$ua         = \$ua->inactivity_timeout(15);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Maximum amount of time in seconds a connection can be inactive before getting closed, defaults to the value of the MOJO_INACTIVITY_TIMEOUT environment variable or 40. Setting the value to 0 will allow connections to be inactive indefinitely."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["inactivity_timeout"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$bool = \$ua->insecure;\n  \$ua      = \$ua->insecure(\$bool);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Do not require a valid TLS certificate to access HTTPS/WSS sites, defaults to the value of the MOJO_INSECURE environment variable."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Disable TLS certificate verification for testing\n  say \$ua->insecure(1)->get('https://127.0.0.1:3000')->result->code;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["insecure"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$loop = \$ua->ioloop;\n  \$ua      = \$ua->ioloop(Mojo::IOLoop->new);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Event loop object to use for blocking I/O operations, defaults to a Mojo::IOLoop object."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["ioloop"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$key = \$ua->key;\n  \$ua     = \$ua->key('/etc/tls/client.crt');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Path to TLS key file, defaults to the value of the MOJO_KEY_FILE environment variable."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["key"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$max = \$ua->max_connections;\n  \$ua     = \$ua->max_connections(5);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Maximum number of keep-alive connections that the user agent will retain before it starts closing the oldest ones, defaults to 5. Setting the value to 0 will prevent any connections from being kept alive."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["max_connections"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$max = \$ua->max_redirects;\n  \$ua     = \$ua->max_redirects(3);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Maximum number of redirects the user agent will follow before it fails, defaults to the value of the MOJO_MAX_REDIRECTS environment variable or 0."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["max_redirects"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$max = \$ua->max_response_size;\n  \$ua     = \$ua->max_response_size(16777216);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Maximum response size in bytes, defaults to the value of \"max_message_size\" in Mojo::Message::Response. Setting the value to 0 will allow responses of indefinite size. Note that increasing this value can also drastically increase memory usage, should you for example attempt to parse an excessively large response body with the methods \"dom\" in Mojo::Message or \"json\" in Mojo::Message."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["max_response_size"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$proxy = \$ua->proxy;\n  \$ua       = \$ua->proxy(Mojo::UserAgent::Proxy->new);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Proxy manager, defaults to a Mojo::UserAgent::Proxy object."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Detect proxy servers from environment\n  \$ua->proxy->detect;\n\n  # Manually configure HTTP proxy (using CONNECT for HTTPS/WebSockets)\n  \$ua->proxy->http('http://127.0.0.1:8080')->https('http://127.0.0.1:8080');\n\n  # Manually configure Tor (SOCKS5)\n  \$ua->proxy->http('socks://127.0.0.1:9050')->https('socks://127.0.0.1:9050');\n\n  # Manually configure UNIX domain socket (using CONNECT for HTTPS/WebSockets)\n  \$ua->proxy->http('http+unix://%2Ftmp%2Fproxy.sock') ->https('http+unix://%2Ftmp%2Fproxy.sock');"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["proxy"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$timeout = \$ua->request_timeout;\n  \$ua         = \$ua->request_timeout(5);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Maximum amount of time in seconds establishing a connection, sending the request and receiving a whole response may take before getting canceled, defaults to the value of the MOJO_REQUEST_TIMEOUT environment variable or 0. Setting the value to 0 will allow the user agent to wait indefinitely. The timeout will reset for every followed redirect."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Total limit of 5 seconds, of which 3 seconds may be spent connecting\n  \$ua->max_redirects(0)->connect_timeout(3)->request_timeout(5);"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["request_timeout"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$server = \$ua->server;\n  \$ua        = \$ua->server(Mojo::UserAgent::Server->new);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Application server relative URLs will be processed with, defaults to a Mojo::UserAgent::Server object."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Mock web service\n  \$ua->server->app(Mojolicious->new);\n  \$ua->server->app->routes->get('/time' => sub (\$c) {\n    \$c->render(json => {now => time});\n  });\n  my \$time = \$ua->get('/time')->result->json->{now};\n\n  # Change log level\n  \$ua->server->app->log->level('fatal');\n\n  # Port currently used for processing relative URLs blocking\n  say \$ua->server->url->port;\n\n  # Port currently used for processing relative URLs non-blocking\n  say \$ua->server->nb_url->port;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["server"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$options = \$ua->socket_options;\n  \$ua         = \$ua->socket_options({LocalAddr => '127.0.0.1'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Additional options for IO::Socket::IP when opening new connections."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["socket_options"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$t = \$ua->transactor;\n  \$ua   = \$ua->transactor(Mojo::UserAgent::Transactor->new);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Transaction builder, defaults to a Mojo::UserAgent::Transactor object."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Change name of user agent\n  \$ua->transactor->name('MyUA 1.0');\n\n  # Disable compression\n  \$ua->transactor->compressed(0);"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["transactor"]
               }
            ],
            "tag"  => "head1",
            "text" => ["ATTRIBUTES"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"Mojo::UserAgent inherits all methods from Mojo::EventEmitter and implements the following new ones."
                  ]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->build_tx(GET => 'example.com');\n  my \$tx = \$ua->build_tx(PUT => 'http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->build_tx(PUT => 'http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->build_tx(PUT => 'http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Generate Mojo::Transaction::HTTP object with \"tx\" in Mojo::UserAgent::Transactor."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Request with custom cookie\n  my \$tx = \$ua->build_tx(GET => 'https://example.com/account');\n  \$tx->req->cookies({name => 'user', value => 'sri'});\n  \$tx = \$ua->start(\$tx);\n\n  # Deactivate gzip compression\n  my \$tx = \$ua->build_tx(GET => 'example.com');\n  \$tx->req->headers->remove('Accept-Encoding');\n  \$tx = \$ua->start(\$tx);\n\n  # Interrupt response by raising an error\n  my \$tx = \$ua->build_tx(GET => 'http://example.com');\n  \$tx->res->on(progress => sub (\$res) {\n    return unless my \$server = \$res->headers->server;\n    \$res->error({message => 'Oh noes, it is IIS!'}) if \$server =~ /IIS/;\n  });\n  \$tx = \$ua->start(\$tx);"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["build_tx"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->build_websocket_tx('ws://example.com');\n  my \$tx = \$ua->build_websocket_tx( 'ws://example.com' => {DNT => 1} => ['v1.proto']);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Generate Mojo::Transaction::HTTP object with \"websocket\" in Mojo::UserAgent::Transactor."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  # Custom WebSocket handshake with cookie\n  my \$tx = \$ua->build_websocket_tx('wss://example.com/echo');\n  \$tx->req->cookies({name => 'user', value => 'sri'});\n  \$ua->start(\$tx => sub (\$ua, \$tx) {\n    say 'WebSocket handshake failed!' and return unless \$tx->is_websocket;\n    \$tx->on(message => sub (\$tx, \$msg) {\n      say \"WebSocket message: \$msg\";\n      \$tx->finish;\n    });\n    \$tx->send('Hi!');\n  });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["build_websocket_tx"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->delete('example.com');\n  my \$tx = \$ua->delete('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->delete('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->delete('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking DELETE request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the DELETE method, which is implied). You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->delete('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["delete"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$promise = \$ua->delete_p('http://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"delete\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->delete_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["delete_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->get('example.com');\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking GET request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the GET method, which is implied). You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->get('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["get"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
                           "  my \$promise = \$ua->get_p('http://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"get\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->get_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["get_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->head('example.com');\n  my \$tx = \$ua->head('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->head('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->head('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking HEAD request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the HEAD method, which is implied). You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->head('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["head"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$promise = \$ua->head_p('http://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"head\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->head_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["head_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->options('example.com');\n  my \$tx = \$ua->options('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->options('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->options('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking OPTIONS request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the OPTIONS method, which is implied). You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->options('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["options"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$promise = \$ua->options_p('http://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"options\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->options_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["options_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->patch('example.com');\n  my \$tx = \$ua->patch('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->patch('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->patch('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking PATCH request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the PATCH method, which is implied). You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->patch('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["patch"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$promise = \$ua->patch_p('http://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"patch\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->patch_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["patch_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->post('example.com');\n  my \$tx = \$ua->post('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->post('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->post('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking POST request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the POST method, which is implied). You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->post('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["post"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$promise = \$ua->post_p('http://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"post\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->post_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["post_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->put('example.com');\n  my \$tx = \$ua->put('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->put('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->put('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking PUT request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the PUT method, which is implied). You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->put('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["put"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
                           "  my \$promise = \$ua->put_p('http://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"put\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->put_p('http://example.com' => json => {a => 'b'})->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["put_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->start(Mojo::Transaction::HTTP->new);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform blocking request for a custom Mojo::Transaction::HTTP object, which can be prepared manually or with \"build_tx\". You can also append a callback to perform requests non-blocking."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->build_tx(GET => 'http://example.com');\n  \$ua->start(\$tx => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["start"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$promise = \$ua->start_p(Mojo::Transaction::HTTP->new);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"start\", but performs all requests non-blocking and returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$tx = \$ua->build_tx(GET => 'http://example.com');\n  \$ua->start_p(\$tx)->then(sub (\$tx) {\n    say \$tx->result->body;\n  })->catch(sub (\$err) {\n    warn \"Connection error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["start_p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->websocket('ws://example.com' => sub {...});\n  \$ua->websocket('ws://example.com' => {DNT => 1} => ['v1.proto'] => sub {...});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Open a non-blocking WebSocket connection with transparent handshake, takes the same arguments as \"websocket\" in Mojo::UserAgent::Transactor. The callback will receive either a Mojo::Transaction::WebSocket or Mojo::Transaction::HTTP object, depending on if the handshake was successful."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->websocket('wss://example.com/echo' => ['v1.proto'] => sub (\$ua, \$tx) {\n    say 'WebSocket handshake failed!' and return unless \$tx->is_websocket;\n    say 'Subprotocol negotiation failed!' and return unless \$tx->protocol;\n    \$tx->on(finish => sub (\$tx, \$code, \$reason) { say \"WebSocket closed with status \$code.\" });\n    \$tx->on(message => sub (\$tx, \$msg) {\n      say \"WebSocket message: \$msg\";\n      \$tx->finish;\n    });\n    \$tx->send('Hi!');\n  });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"You can activate permessage-deflate compression by setting the Sec-WebSocket-Extensions header, this can result in much better performance, but also increases memory usage by up to 300KiB per connection."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->websocket('ws://example.com/foo' => {\n    'Sec-WebSocket-Extensions' => 'permessage-deflate'\n  } => sub {...});"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["websocket"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$promise = \$ua->websocket_p('ws://example.com');"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Same as \"websocket\", but returns a Mojo::Promise object instead of accepting a callback."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ua->websocket_p('wss://example.com/echo')->then(sub (\$tx) {\n    my \$promise = Mojo::Promise->new;\n    \$tx->on(finish => sub { \$promise->resolve });\n    \$tx->on(message => sub (\$tx, \$msg) {\n      say \"WebSocket message: \$msg\";\n      \$tx->finish;\n    });\n    \$tx->send('Hi!');\n    return \$promise;\n  })->catch(sub (\$err) {\n    warn \"WebSocket error: \$err\";\n  })->wait;"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["websocket_p"]
               }
            ],
            "tag"  => "head1",
            "text" => ["METHODS"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"You can set the MOJO_CLIENT_DEBUG environment variable to get some advanced diagnostics information printed to STDERR."
                  ]
               },
               {
                  "tag"  => "Verbatim",
                  "text" => ["  MOJO_CLIENT_DEBUG=1"]
               }
            ],
            "tag"  => "head1",
            "text" => ["DEBUGGING"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"Mojolicious, Mojolicious::Guides, https://mojolicious.org."
                  ]
               }
            ],
            "tag"  => "head1",
            "text" => ["SEE ALSO"]
         }
      ],
      expected_find_title =>
        "Mojo::UserAgent - Non-blocking I/O HTTP and WebSocket user agent",
      method               => "get",
      expected_find_method => [
         "get:",
         "",
"  my \$tx = \$ua->get('example.com');\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => 'Content!');\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$tx = \$ua->get('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});",
         "",
"  Perform blocking GET request and return resulting\n  Mojo::Transaction::HTTP object, takes the same arguments as\n  \"tx\" in Mojo::UserAgent::Transactor (except for the GET\n  method, which is implied). You can also append a callback to\n  perform requests non-blocking.",
         "",
"  \$ua->get('http://example.com' => json => {a => 'b'} => sub (\$ua, \$tx) { say \$tx->result->body });\n  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;",
         "",
      ],
      expected_find_method_summary =>
"Perform blocking GET request and return resulting Mojo::Transaction::HTTP object, takes the same arguments as \"tx\" in Mojo::UserAgent::Transactor (except for the GET method, which is implied). You can also append a callback to perform requests non-blocking.",
      expected_find_events => {
         "prepare" =>
"Emitted whenever a new transaction is being prepared, before relative URLs are rewritten and cookies added. This includes automatically prepared proxy CONNECT requests and followed redirects.",
         "start" =>
"Emitted whenever a new transaction is about to start. This includes automatically prepared proxy CONNECT requests and followed redirects.",
      },
   },
);

# TODO: Tidy up after restructuring Pod::Query.
$Pod::Query::MOCK_ROOT = 1;
{
   no warnings 'redefine';
   *Pod::Query::_class_to_path = sub { "$class_dir/" . shift() . ".pm" };
}

for my $case ( @cases ) {
   pass
"=== Starting $case->{pod_class} - $case->{name} - method:$case->{method} ===";

   # TODO: Tidy up after restructuring Pod::Query.
   {
      no warnings 'redefine';
      *Pod::Query::_mock_root = sub { $case->{lol} };
   }

   my $query = Pod::Query->new( $case->{pod_class} );

   # path.
   is_deeply( $query->{path}, "$class_dir/$case->{pod_class}.pm", "path", );

   # tree.
   is_deeply( $query->{tree}, $case->{expected_tree}, "tree", );

   # find_title.
   is(
      $query->find_title(),
      $case->{expected_find_title},
      "find_title - scalar context"
   );
   is_deeply(
      [ $query->find_title ],
      [ $case->{expected_find_title} ],
      "find_title - list context"
   );

   # find_method.
   is(
      scalar $query->find_method( $case->{method} ),
      join( "\n", @{ $case->{expected_find_method} } ),
      "find_method($case->{method}) - scalar context"
   );
   is_deeply(
      [ $query->find_method( $case->{method} ) ],
      [ @{ $case->{expected_find_method} } ],
      "find_method($case->{method}) - list context"
   );

   # find_method_summary.
   is(
      scalar $query->find_method_summary( $case->{method} ),
      $case->{expected_find_method_summary},
      "find_method_summary($case->{method}) - scalar context"
   );
   is_deeply(
      [ $query->find_method_summary( $case->{method} ) ],
      [ $case->{expected_find_method_summary} ],
      "find_method_summary($case->{method}) - list context"
   );

   # find_events.
   is_deeply(
      { $query->find_events },
      $case->{expected_find_events},
      "find_events - list context"
   );
}

done_testing();

