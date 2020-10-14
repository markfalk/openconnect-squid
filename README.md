# openconnect-squid

A container to allow an OpenConnect VPN connection to be used via a [squid](http://www.squid-cache.org/) proxy.

Supported variables:
- `ANYCONNECT_SERVER` = Server to connect to
- `KEEP_ALIVE_URL` = URL for keep alive (defaults to $ANYCONNECT_SERVER)
- `KEEP_ALIVE_TIMEOUT` = Seconds to sleep between Keep Alive URL requests (defaults to 300 seconds)
- `LOG_STDOUT` = set to true to enable logs to the terminal

A typical invocation:
```
>docker run --privileged -p 4128:3128/tcp -e LOG_STDOUT=true -e ANYCONNECT_SERVER=https://<VPN_URL> -i -t mfalk/openconnect-squid:latest
[2020-10-14 22:43:09] POST https://<VPN_URL>/
[2020-10-14 22:43:09] Connected to X.X.X.X:443
[2020-10-14 22:43:09] SSL negotiation with <VPN_URL>
[2020-10-14 22:43:09] Connected to HTTPS on <VPN_URL> with ciphersuite TLSv1.2-ECDHE-RSA-AES256-GCM-SHA384
[2020-10-14 22:43:09] Got HTTP response: HTTP/1.0 302 Object Moved
[2020-10-14 22:43:09] GET https://<VPN_URL>/
[2020-10-14 22:43:09] Connected to X.X.X.X:443
[2020-10-14 22:43:09] SSL negotiation with <VPN_URL>
[2020-10-14 22:43:09] Connected to HTTPS on <VPN_URL> with ciphersuite TLSv1.2-ECDHE-RSA-AES256-GCM-SHA384
[2020-10-14 22:43:09] Got HTTP response: HTTP/1.0 302 Object Moved
[2020-10-14 22:43:09] GET https://<VPN_URL>/+webvpn+/index.html
[2020-10-14 22:43:09] SSL negotiation with <VPN_URL>
[2020-10-14 22:43:09] Connected to HTTPS on <VPN_URL> with ciphersuite TLSv1.2-ECDHE-RSA-AES256-GCM-SHA384
Please enter your username and password.
GROUP: [XX]:XX
Please enter your username and password.
Username:
Password:
[2020-10-14 22:43:16] POST https://<VPN_URL>/+webvpn+/index.html
Please select your second authentication method [num]:
1 - Okta Verify.
2 - Okta Verify Push.
3 - SMS Authentication.
4 - Google Authenticator.
Enter '0' to abort.

Response:
[2020-10-14 22:43:24] POST https://<VPN_URL>/+webvpn+/login/challenge.html
Enter the code for Google Authenticator.
Enter '0' to abort.

Response:
[2020-10-14 22:43:27] POST https://<VPN_URL>/+webvpn+/login/challenge.html
[2020-10-14 22:43:28] Got CONNECT response: HTTP/1.1 200 OK
[2020-10-14 22:43:28] CSTP connected. DPD 30, Keepalive 20
[2020-10-14 22:43:28] Connected as X.X.X.X, using SSL, with DTLS in progress
[2020-10-14 22:43:28] Continuing in background; pid 12
[2020-10-14 22:43:29] Established DTLS connection (using OpenSSL). Ciphersuite DTLSv1.2-ECDHE-ECDSA-AES256-GCM-SHA384.
2020/10/14 22:43:32| WARNING: BCP 177 violation. Detected non-functional IPv6 loopback.
WARNING: Cannot write log file: stdio:/dev/stderr
stdio:/dev/stderr: Permission denied
         messages will be sent to 'stderr'.
2020/10/14 22:43:32| Created PID file (/var/run/squid.pid)
2020/10/14 22:43:33| Set Current Directory to /var/cache/squid
WARNING: Cannot write log file: stdio:/dev/stderr
stdio:/dev/stderr: Permission denied
         messages will be sent to 'stderr'.
2020/10/14 22:43:33| Starting Squid Cache version 4.12 for x86_64-alpine-linux-musl...
2020/10/14 22:43:33| Service Name: squid
2020/10/14 22:43:33| Process ID 54
2020/10/14 22:43:33| Process Roles: master worker
2020/10/14 22:43:33| With 1048576 file descriptors available
2020/10/14 22:43:33| Initializing IP Cache...
2020/10/14 22:43:33| DNS Socket created at X.X.X.X, FD 7
2020/10/14 22:43:33| Adding nameserver X.X.X.X from /etc/resolv.conf
2020/10/14 22:43:33| Adding nameserver X.X.X.X from /etc/resolv.conf
2020/10/14 22:43:33| Logfile: opening log stdio:/dev/stderr
2020/10/14 22:43:33| Local cache digest enabled; rebuild/rewrite every 3600/3600 sec
2020/10/14 22:43:33| Logfile: opening log stdio:/dev/stderr
2020/10/14 22:43:33| Swap maxSize 0 + 262144 KB, estimated 20164 objects
2020/10/14 22:43:33| Target number of buckets: 1008
2020/10/14 22:43:33| Using 8192 Store buckets
2020/10/14 22:43:33| Max Mem  size: 262144 KB
2020/10/14 22:43:33| Max Swap size: 0 KB
2020/10/14 22:43:33| Using Least Load store dir selection
2020/10/14 22:43:33| Set Current Directory to /var/cache/squid
2020/10/14 22:43:33| Finished loading MIME types and icons.
2020/10/14 22:43:33| HTCP Disabled.
2020/10/14 22:43:33| Squid plugin modules loaded: 0
2020/10/14 22:43:33| Adaptation support is off.
2020/10/14 22:43:33| Accepting HTTP Socket connections at local=X.X.X.X:3128 remote=[::] FD 10 flags=9
2020/10/14 22:43:34| storeLateRelease: released 0 objects
```

This will forward local port 4128 to the standard squid proxy of 3128.

Note:
- System will send a curl of the $ANYCONNECT_SERVER URL every $KEEP_ALIVE_TIMEOUT as a keep-alive
- Terminal will be tied up as the squid session is not placed in the background
- Terminal must be closed in order to establish a new connection