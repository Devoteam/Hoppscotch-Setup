# .env File Placeholders
ENV_FILE=".env"
ENV_KEYS=("GITHUB_CLIENT_ID_VALUE" "GITHUB_CLIENT_ID_SECRET_VALUE" "GOOGLE_CLIENT_ID_VALUE" "GOOGLE_CLIENT_SECRET_VALUE" "POSTGRES_PASSWORD_VALUE" "HOPPSCOTCH_DOMAIN" "SMTP_USER" "SMTP_PASSWORD" "EXAMPLE_MAIL")

# docker-compose.yml File Placeholders
DOCKER_FILE="docker-compose.yml"
DOCKER_KEYS=("POSTGRES_PASSWORD_VALUE" "TRAEFIK_HASHED_DASHBOARD_PASSWORD" "HOPPSCOTCH_DOMAIN")
replace_value() {
    key="$1"
    value="${!key}"
    file="$2"
    awk -v key="$key" -v value="$value" '{gsub(key, value)}1' "$file" > temp && mv temp "$file"
}

# Replace all placeholder values in the .env file
for key in "${ENV_KEYS[@]}"; do
    replace_value "$key" "$ENV_FILE"
done
echo "Values replaced successfully in $ENV_FILE"

for key in "${DOCKER_KEYS[@]}"; do
    replace_value "$key" "$DOCKER_FILE"
done
echo "Values replaced successfully in $DOCKER_FILE"
