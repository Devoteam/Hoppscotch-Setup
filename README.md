# Hoppscotch-Setup

An instruction for deploying self-hosted Hoppscotch service!

## ENV

### .env example
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

`DATABASE_URL`

`JWT_SECRET`
`TOKEN_SALT_COMPLEXITY`
`MAGIC_LINK_TOKEN_VALIDITY`
`REFRESH_TOKEN_VALIDITY`
`ACCESS_TOKEN_VALIDITY`
`SESSION_SECRET`

`REDIRECT_URL`
`WHITELISTED_ORIGINS`

`VITE_ALLOWED_AUTH_PROVIDERS`

`GITHUB_CLIENT_ID`
`GITHUB_CLIENT_SECRET`
`GITHUB_CALLBACK_URL`

`GOOGLE_CLIENT_ID`
`GOOGLE_CLIENT_SECRET`
`GOOGLE_CALLBACK_URL`
`GOOGLE_SCOPE`

`RATE_LIMIT_TTL`
`RATE_LIMIT_MAX`

`VITE_BASE_URL`
`VITE_SHORTCODE`
`VITE_ADMIN_URL`
`VITE_BACKEND_GQL_URL`
`VITE_BACKEND_WS_URL`
`VITE_BACKEND_API_URL`

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
