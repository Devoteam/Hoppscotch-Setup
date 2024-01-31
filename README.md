# Hoppscotch-Setup
An instruction for deploying self-hosted Hoppscotch service with Treaffik!

> [!NOTE]
> This documentation is heavily based on the Official documentation. Pls, check out the [official Hoppschotch documentation](https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build).

## Setup
For the deployment, some stuff is needed. 
First, you need the official repository of Hopscotch.

```
git clone https://github.com/hoppscotch/hoppscotch.git
cd hoppscotch
mkdir certs
mkdir tlsconfig
```
After cloning the official Hopscotch repository it is recommended to use the yml file that this repository delivers because Treaffik is preconfigured and only small changes have to be made so that Hoppschotch can be used with TLS encryption.

The service desk (It) asked to create the Certificates for the Server. The Certificates should be stored in the Cloned folder in a certs folder.
in the tlsconfig folder [Contribution guidelines for this project](README.md)

   
## env
Copy the contents of the .env.example file found in the root directory of the cloned repository to .env or use the provided .env.example file of this repository and add your values for the environment variables.

### .env example
> [!NOTE]
> This is only an example of the .env. This env only has minor changes but if you need more information or other Auth methods pls check on the official documentation (https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build).

>  [!CAUTION]
> Ensure that the environment values are not enclosed within quotes.
> like this:`DATABASE_URL=<postgresql://username:password@url:5432/dbname>` not like this `DATABASE_URL='<postgresql://username:password@url:5432/dbname>'`

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

### Description of the Values in .env 
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
      - `GITHUB_CLIENT_ID`: 
      - `GITHUB_CLIENT_SECRET`:
      - `GITHUB_CALLBACK_URL`:
   - Google Auth Config
      - `GOOGLE_CLIENT_ID`:
      - `GOOGLE_CLIENT_SECRET`:
      - `GOOGLE_CALLBACK_URL`:
      - `GOOGLE_SCOPE`:
   - Other Auth
      - If you want to add the other auth methods read the official documentation (https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build).
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

## tls config
```
tls:
  stores:
    default:
      defaultCertificate:
        certFile: /etc/certs/devli106.pem
        keyFile: /etc/certs/devli106_key.pem

```
## Docker-compose file
The docker file needs some changes so Hopscotch will work.

### Changes in the docker file


```
docker-compose -f <file.yaml> up
```
### Migration
```
docker exec -it <container_id> /bin/sh
```
 
```
pnpx prisma migrate deploy
```
