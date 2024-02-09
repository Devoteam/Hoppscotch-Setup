# Hoppscotch-Setup
An instruction for deploying self-hosted Hoppscotch service with Treafik!

> [!NOTE]
> This documentation is heavily based on the Official documentation. Please, check out the [Official Hoppschotch Documentation](https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build).

# Table of Contents
1. [Setup](#setup)
1. [Docker Compose File](#docker-compose-file)
1. [TLS Configuration](#tls-configuration)
    * [Example Configuration](#example-configuration)
1. [Proxy](#proxy)
1. [Hoppscotch Environment File](#hoppscotch-environment-file)
    * [Example Environment File Configuration](#example-environment-file-configuration)
    * [Description of Values](#description-of-values)  
1. [Migration](#migration)
1. [Sensitive Values](#sensitive-values)
## Setup
1. First, you need the official Hoppscotch repository.

```
git clone https://github.com/hoppscotch/hoppscotch.git
```
2. After cloning the official Hoppscotch repository you should clone the contents of this repository aswell. 

```
git clone https://github.com/Devoteam/Hoppscotch-Setup.git
```
3. Clone the Hoppscotch-Proxy repository
```
git clone https://github.com/hoppscotch/proxyscotch.git
```
* Your directory structure should look like this: 
```text
    opt/                                      <- repository root
    ├─ hoppscotch/                            <- Official hoppscotch repository  
    ├─ Hoppscotch-Setup/                      <- This repository
    ├─ proxyscotch/                           <- Official Hoppscotch-Proxy repository
```
4. Replace the contents of the Hoppscotch repository with the contents of this repository
5. Setup the Secrets stored in the ```hoppscotch.kdbx``` file as Environment Variables on the host system
```
export GITHUB_CLIENT_ID_VALUE='*********'
```  
* hoppscotch.kdbx is sent via E-Mail. If you want to setup the values yourself, you can check the required Environment Variable Key names in setup.sh ENV_KEYS and DOCKER_KEYS 
6. Run setup.sh from within the hoppscotch directory, to fill in the Environbment Variables from the previous step in the docker-compose and .env files. For more information see [Sensitive Values](#sensitive-values)
7. Run ```docker-compose -f docker-compose.yml up``` to start the treafik, hoppscotch, proxy and postgres containers. 
8. Run ```docker run -it --network hoppscotch --env-file .env hoppscotch-hoppscotch-aio pnpx prisma migrate deploy``` to setup the database.
9. Wait for the hoppscotch-aio container to become healthy  
10. You can visit the hoppscotch app on http://HOPPSCOTCH_DOMAIN.com/ and admin dashboard on http://admin.HOPPSCOTCH_DOMAIN/
11. If you get a `Could not send request` issues, please configure the [Interceptor](#proxy)

> [!NOTE]
> Hoppschotch can be set up to use TLS, see [TLS configuration](#tls-configuration).

## Docker-compose file
Hoppscotch all-in-one docker-compose.yml with Traefik reverse-proxy and hoppscotch-proxy integration. 

We use Traefik docker-compose labels to route requests to the proxy, frontend, admin and backend pages. 
>  [!CAUTION]
> The admin page cannot be served as a folder of the main domain, it has to have its own domain name, E.G. ```admin.mydomain.com```

## TLS configuration
By default certificates have to be uploaded to the ```/hoppscotch/certs``` directory, the docker-compose then creates a volume ```/hoppscotch/certs:/etc/certs```

The TLS certificate needs to be in the ```.pem``` format. The service desk (IT Team) create the Certificates for the Server. 
>  [!CAUTION]
> The Certificates should only be stored on the server. 

Treafiks TLS defaults are defined in the ```./tlsconf/certs-traefik.yml```.

The Traefik Container expects a certificate location of ```/etc/certs/```, it can be configured from ```/tlsconf/certs-traefik.yml```

### Example configuration
```
tls:
  certificates:
    - certFile: /etc/certs/cert1
      keyFile: /etc/certs/key1
    - certFile: /etc/certs/cert2
      keyFile: /etc/certs/key2

```
## Proxy
Use of Hoppscotch requires a proxy due to CORS, possible options are the [Hoppscotch Browser Extension](https://docs.hoppscotch.io/documentation/features/interceptor), or [Proxyscotch](https://github.com/hoppscotch/proxyscotch).

The docker-compose file spins up a Proxyscotch container on `proxy.HOPPSCOTCH_DOMAIN`.

To use the proxy go to Settings>Interceptor, enable the `Use the proxy middleware to send requests` and change the Proxy URL to: https://proxy.HOPPSCOTCH_DOMAIN

## Hoppscotch environment file
All the environment variables required for Hoppscotch to work are provided in the ```.env``` file. 

> [!NOTE]
> This is only an example of the ```.env``` file with placeholders, as to not commit any secrets in plain text to the git repository.
> Secrets are stored in the KeePass ```hoppscotch.kdbx``` file. 
> To easily replace the placeholders with the correct values you can use the bash script ```setup.sh```  
> Currently only Google Auth and GitHub Auth are configured, if further Auth methods need to be setup, please refer to the [official Hoppschotch documentation](https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build).

>  [!CAUTION]
> Ensure that the environment values are not enclosed within quotes.
> Should look like this:`REDIRECT_URL=<base url>` and not like this `REDIRECT_URL='<base url>'`


### Example environment file configuration
```
#-----------------------Backend Config------------------------------#
# Prisma Config
DATABASE_URL=<postgresql://username:password@url:5432/dbname>


# Auth Tokens Config
JWT_SECRET=secret1233
TOKEN_SALT_COMPLEXITY=10
MAGIC_LINK_TOKEN_VALIDITY= 3
REFRESH_TOKEN_VALIDITY=604800000 # Default validity is 7 days (604800000 ms) in ms
ACCESS_TOKEN_VALIDITY=86400000 # Default validity is 1 day (86400000 ms) in ms
SESSION_SECRET='add some secret here'

# Hoppscotch App Domain Config
REDIRECT_URL=<base url>
WHITELISTED_ORIGINS=<app url, backend url, admin Url>
VITE_ALLOWED_AUTH_PROVIDERS=GOOGLE,GITHUB

# Github Auth Config
GITHUB_CLIENT_ID=******
GITHUB_CLIENT_SECRET=******
GITHUB_CALLBACK_URL=<backend url>/v1/auth/github/callback
GITHUB_SCOPE=user:email

# Google Auth Config
GOOGLE_CLIENT_ID=******
GOOGLE_CLIENT_SECRET=******
GOOGLE_CALLBACK_URL=https:<backend url>/v1/auth/google/callback
GOOGLE_SCOPE=email,profile

# Rate Limit Config
RATE_LIMIT_TTL=60 # In seconds
RATE_LIMIT_MAX=100 # Max requests per IP


#-----------------------Frontend Config------------------------------#

# Base URLs
VITE_BASE_URL=<base url>

VITE_SHORTCODE=<base url>

VITE_ADMIN_URL=<admin url>

# Backend URLs
VITE_BACKEND_GQL_URL=<backend url>/graphql
VITE_BACKEND_WS_URL=<backend url>/graphql
VITE_BACKEND_API_URL=<backend url>/v1

# Terms Of Service And Privacy Policy Links (Optional)
VITE_APP_TOS_LINK=https://docs.hoppscotch.io/support/terms
VITE_APP_PRIVACY_POLICY_LINK=https://docs.hoppscotch.io/support/privacy
```

### Description of values 
1. Prisma Config
   - `DATABASE_URL`: This is where you add your Postgres database URL.
2. Auth Tokens Config
   - `JWT_SECRET`, `SESSION_SECRET`: Secret Keys for security purposes.
   - `TOKEN_SALT_COMPLEXITY`: Defines the complexity of the SALT that is used for hashing - a higher number implies a more complex salt.
   - `MAGIC_LINK_TOKEN_VALIDITY`: Duration of the validity of the magic link being sent to sign in to Hoppscotch (in days).
   - `REFRESH_TOKEN_VALIDITY`: Validity of the refresh token for auth (in ms).
   - `ACCESS_TOKEN_VALIDITY`: Validity of the access token for auth (in ms).
3. Hoppscotch App Domain Config
   - `REDIRECT_URL`: This is a fallback URL to debug when the actual redirects fail.
   - `WHITELISTED_ORIGINS`: URLs of Hoppscotch backend, admin dashboard, and the frontend app.
4. Auth config
   - `VITE_ALLOWED_AUTH_PROVIDERS`: Allows you to specify which auth providers you want to enable. Options are Google, Github, Microsoft, and email.
   - Github Auth Config
      - to create a [Github OAuth Apps](https://github.com/settings/developers).
      - `GITHUB_CLIENT_ID`: The ID which is generated by GitHub.
      - `GITHUB_CLIENT_SECRET`: The secret which is generated by GitHub.
      - `GITHUB_CALLBACK_URL`: The Url should be the same in Github and and in the .env.
   - Google Auth Config
      - to make the Google auth work connected to the Servicedesk. They will provide you with GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET.
      - `GOOGLE_CLIENT_ID`: Information is provided from Servicedesk.
      - `GOOGLE_CLIENT_SECRET`: Information is provided from Servicedesk.
      - `GOOGLE_CALLBACK_URL`: Inform the Servicedesk with the correct CALLBACK_URL.
   - Other Auth
      - If you want to add the other auth methods read the [official Hoppschotch documentation](https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build).
5. Rate Limit Config 
   - `RATE_LIMIT_TTL`: The time it takes to refresh the maximum number of requests being received.
   - `RATE_LIMIT_MAX`: The maximum number of requests that Hoppscotch can handle under RATE_LIMIT_TTL.
6. Base URLs
   - `VITE_BASE_URL`:  This is the URL where your deployment will be accessible from.
   - `VITE_SHORTCODE`:  A URL to generate shortcodes for sharing, can be the same as VITE_BASE_URL.
   - `VITE_ADMIN_URL`: This is the URL which your Admin page will be accessible from.
7. Backend URLs
   - `VITE_BACKEND_GQL_URL`: The URL for GraphQL within the instance.
   - `VITE_BACKEND_WS_URL`: The URL for WebSockets within the instance.
   - `VITE_BACKEND_API_URL`: The URL for REST APIs within the instance.

## Migration
If you are getting `Status Code 500` from the backend, when for example trying to log in, you should [run a migration](https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build#running-migrations)

```
docker exec -it hoppscotch-aio pnpx prisma migrate deploy
```

## Sensitive values
As to not store any sensitive values in this git repository, some values in the ```.env``` and ```docker-compose.yml``` files have been replaced with placeholders. You can use the ```setup.sh``` bash script to automatically set up these values from local environment variables.

Before you run ```setup.sh``` you need to have defined the following environment variables: 

* GITHUB_CLIENT_ID_VALUE
* GITHUB_CLIENT_ID_SECRET_VALUE
* GOOGLE_CLIENT_ID_VALUE
* GOOGLE_CLIENT_SECRET_VALUE
* POSTGRES_PASSWORD_VALUE
* TRAEFIK_HASHED_DASHBOARD_PASSWORD
* HOPPSCOTCH_DOMAIN

>  [!CAUTION]
> Make sure not to commit any sensitive information to this repository.