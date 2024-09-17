
#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 --guid <guid> --api_key <api_key> --sapi_key <sapi_key> [--target] --title <title_id> --env <prod|staging|dev>"
  exit 1
}

# Default settings
TARGET_QUESTS_PATH="get-target-quests"
BASE_URL="eco"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --guid) GUID="$2"; shift ;;
    --api_key) API_KEY="$2"; shift ;;
    --sapi_key) SAPI_KEY="$2"; shift ;;
    --target) TARGET_QUESTS_PATH="get-quests" ;;
    --title) TITLE="$2"; shift ;;
    --env)
      case $2 in
        prod) BASE_URL="eco";;
        staging) BASE_URL="ecostaging";;
        dev) BASE_URL="ecodev";;
        *) echo "Invalid environment option. Choose from: prod, staging, dev"; usage ;;
      esac
      shift ;;
    *) usage ;;
  esac
  shift
done

# Check if all required arguments are provided
if [ -z "$GUID" ] || [ -z "$API_KEY" ] || [ -z "$SAPI_KEY" ] || [ -z "$TITLE" ]; then
  usage
fi
#https://eu-central-1-xpromo2-sapi.eco.stillfront.com/v1/init?player_id=${GUID}&title_id=88
# Step 1: Perform the first curl to get the token
response=$(curl -s -X 'GET' \
  "https://eu-central-1-xpromo2-sapi.${BASE_URL}.stillfront.com/v1/init?player_id=${GUID}&title_id=${TITLE}" \
  -H 'accept: application/json' \
  -H "x-api-key: ${SAPI_KEY}" \
  -H 'content-type: application/json')

# Extract the token from the response
token=$(echo "$response" | jq -r '.token')

# Check if the token is extracted successfully
if [ -z "$token" ]; then
  echo "Failed to extract token from response: $response"
  exit 1
fi

echo "Token retrieved: $token"

# Step 2: Use the extracted token in the second request, optionally modifying the endpoint
response2=$(curl -s -X 'GET' \
  "https://eu-central-1-xpromo2-api.${BASE_URL}.stillfront.com/v1/${TARGET_QUESTS_PATH}" \
  -H 'accept: application/json' \
  -H "authorization: Bearer ${token}" \
  -H "x-api-key: ${API_KEY}" \
  -H 'content-type: application/json')

# Pretty-print the JSON response of the second curl
echo "Response from second request:"
echo "$response2" | jq '.'
