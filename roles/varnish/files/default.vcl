# This is a basic VCL configuration file for varnish. See the vcl(7)
# man page for details on VCL syntax and semantics.
#
# Default backend definition. Set this to point to your content
# server.
#
#backend default {
# .host = "127.0.0.1";
# .port = "80";
#}
backend media {
	.host = "192.118.68.142";
	.port = "http";
}
backend wallatours {
	.host = "www.wallatours.co.il";
	.port = "http";
	.first_byte_timeout = 900s;
}
backend wallashops {
	.host = "cw3.wallashops.co.il";
	.port = "http";
}
backend wshopsimg {
        .host = "ypk.cs4u.co.il";
        .port = "http";
}
backend bantux {
	.host = "192.118.70.50";
	.port = "http";
}
backend xadt {
	.host = "192.118.82.180";
	.port = "http";
}
#backend pics2 {
#    .host = "192.118.69.54";
#    .port = "80";
#    .first_byte_timeout = 300s;
#}

backend pics13 {
    .host = "192.118.69.54";
    .port = "80";
    .first_byte_timeout = 300s;
}

backend jobcity {
    .host = "192.118.82.181";
    .port = "80";
}

backend mazaltov {
    .host = "192.118.82.156";
    .port = "80";
}

backend imgjobcity {
    .host = "192.118.70.112";
    .port = "80";
}
backend vgames {
    .host = "192.118.70.211";
    .port = "80";
}
backend zahavru {
	.host = "192.118.82.206";
	.port = "80";
}

# hosts allowed to purge
acl purge {
	"localhost";
	"192.118.70.0"/24;
	"192.118.71.0"/24;
	"192.118.81.0"/24;
	"192.118.68.0"/24;
}

sub vcl_recv {
        set req.grace = 10m;

        if (req.url ~ "\.(png|gif|jpg|ico|jpeg|swf|css|js|mp4|xml|html|flv)$") {
                unset req.http.cookie;
        }
	if (req.url ~ "\.(mp4)$") {
		#set obj.http.Content-Type = "video/mp4; charset=utf-8";
		#set req.http.Content-Type = "video/mp4; charset=utf-8";
		#set beresp.http.Content-Type = "video/mp4";
	}

        if (req.http.host ~ "^isc.{0,3}.(wcdn|walla).co.il$" 
            || req.http.host ~ "ico.walla.co.il$" 
            || req.http.host ~ "i.walla.co.il$" 
            || req.http.host ~ "banners.walla.co.il$"
            || req.http.host ~ "sisc.wcdn.co.il$" ) {
                set req.url = regsub(req.url, "\?.*", "");
                set req.http.host = "isc.walla.co.il";
                set req.backend = media;
        } elsif (req.http.host ~ "(?i)^msc(wbe|wne|wza|wgd|wba)?([0-9])?.(wcdn|walla).co.il$" 
		 || req.http.host ~"mm.walla.co.il$" 
		 || req.http.host ~ "m(a|e)d.walla.co.il$"
		 || req.http.host ~ "smsc.wcdn.co.il$"
		 || req.http.hots ~ "ii.walla.co.il$") {
                set req.http.host = "msc.walla.co.il";
                set req.backend = media;
        } elsif (req.http.host ~ "^wssc.{0,3}.(wcdn|walla).co.il$") {
                set req.http.host = "cw3.wallashops.co.il";
                set req.backend = wallashops;
        } elsif (req.http.host ~ "^xsc.{0,3}.(wcdn|walla).co.il$" ||
                req.http.host ~ "xban.walla.co.il$") {
                set req.http.host = "xsc.walla.co.il";
                set req.backend = bantux;
        } elsif (req.http.host ~ "^wscwt4\..+") {
                set req.http.host = "www.wallatours.co.il";
                set req.backend = wallatours;
        } elsif (req.http.host ~ "x(wbe|wne|wgd|wza)?.(wcdn|walla).co.il" ||
                req.http.host ~ "vsc(wbe|wne|wgd|wza)?.walla.co.il" || req.http.host ~"varnish3.walla.co.il" || req.http.host ~ "sx.wcdn.co.il" ) {
                set req.url = regsub(req.url, "\?.*", "");
                set req.http.host = "x.wcdn.co.il";
                set req.backend = xadt;
        } elsif (req.http.host ~ "cache(01|02|03|04|05|06|0101|0301|0401|0501|0601)?.mekusharim.co.il" ||
	req.http.host ~ "pics(02|13)?.mekusharim.co.il" ||
	req.http.host ~ "micos.mekusharim.co.il") {
		set req.http.host = "pics13.mekusharim.co.il";
		set req.backend = pics13;
	} elsif (req.http.host ~ "static(1|2|3)?.jobs.yad2.co.il") {
        	set req.http.host = "jobs.yad2.co.il";
        	set req.backend = jobcity;
	} elsif (req.http.host ~ "static(1|2|3)?.jobcity.co.il") {
                set req.http.host = "static.jobcity.co.il";
                set req.backend = jobcity;
 	} elsif (req.http.host ~ "img.mazaltov.walla.co.il") {
        	set req.http.host = "mazaltov.walla.co.il";
        	set req.backend = mazaltov;
  	} elsif (req.http.host ~ "img.jobcity.co.il") {
        	set req.backend = imgjobcity;
	} elsif (req.http.host ~ "img.jobs.yad2.co.il") {
		set req.http.host = "img.jobs.yad2.co.il";
                set req.backend = imgjobcity;
	} elsif (req.http.host ~ "vgames.co.il") {
                set req.http.host = "vgames.down.walla.co.il";
                set req.backend = vgames;
    	} elsif (req.http.host ~ "images.zahav.ru") {
		set req.http.host = "images.zahav.ru";
		set req.backend = zahavru;
	 } elsif (req.http.host ~ "^l.(walla|wcdn).co.il$") {
                set req.http.host = "l.walla.co.il";
                set req.backend = media;
	} elsif (req.http.host ~ "^shops.wcdn.co.il$") {
                set req.http.host = "ypk.cs4u.co.il";
                set req.backend = wshopsimg;

	} else {
                error 404 "UVH";
}

	if (req.request == "PURGE") {
	if (!client.ip ~ purge) {
		error 405 "Not allowed.";
}
}
# ababa
	if (req.http.x-forwarded-for) {
		set req.http.X-Forwarded-For =
		req.http.X-Forwarded-For + ", " + client.ip;
	} else {
		set req.http.X-Forwarded-For = client.ip;
}
	if (req.request != "GET" &&
		req.request != "HEAD" &&
		req.request != "PUT" &&
		req.request != "POST" &&
		req.request != "TRACE" &&
		req.request != "OPTIONS" &&
		req.request != "PURGE" &&
		req.request != "DELETE") {
		/* Non-RFC2616 or CONNECT which is weird. */
		return (pipe);
}
	if (req.request != "GET" && req.request != "HEAD" && req.request != "PURGE") {
		return (pass);
}
	if (req.http.Authorization || req.http.Cookie) {
		/* Not cacheable by default */
		return (pass);
}
	return (lookup);
}
# sub vcl_pipe {
# # Note that only the first request to the backend will have
# # X-Forwarded-For set. If you use X-Forwarded-For and want to
# # have it set for all requests, make sure to have:
# # set bereq.http.connection = "close";
# # here. It is not set by default as it might break some broken web
# # applications, like IIS with NTLM authentication.
# return (pipe);
# }
#
sub vcl_pass {
	return (pass);
}
#
sub vcl_hash {
	hash_data(req.url);
	if (req.http.host) {
		hash_data(req.http.host);
	} else {
		hash_data(server.ip);
	}
	return (hash);
	}
sub vcl_hit {
	if (req.request == "PURGE") {
		set obj.ttl = 0s;
		error 200 "Purged.";
}
return(deliver);
}
sub vcl_miss {
	if (req.request == "PURGE") {
		error 404 "Not in cache.";
}
return (fetch);
}
## For Tayarut
sub vcl_fetch {
	unset beresp.http.Set-Cookie;
	unset beresp.http.Etag;
	unset beresp.http.Server;
	unset beresp.http.X-Powered-By;
	if(beresp.status == 404) {
		return(hit_for_pass);
	}
	if (beresp.ttl <= 0s) {
		return(hit_for_pass);
	} else {
		unset beresp.http.expires;
		set beresp.http.Cache-Control = "max-age = 315360000";
		set beresp.ttl = 1w;
		set beresp.http.magicmarker = "1";
}
return(deliver);
}
sub vcl_deliver {
	if (obj.hits > 0) {
		set resp.http.X-Cache = "HIT";
	} else {
		set resp.http.X-Cache = "MISS";
        }
	set resp.http.X-DoIT = "Yes";

return (deliver);
}
sub vcl_init {
	return (ok);
}
#
sub vcl_fini {
	return (ok);
}
