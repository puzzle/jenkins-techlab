#!/bin/bash
set -euo pipefail

export VERSIONS_FILE=versions.json
export SIGNATURES_FILE=versions-with-sigs.json


# Verifies all required environment variables are set.
check_env_vars() {
  : "${ORG:?Missing ORG}"
  : "${PACKAGE_NAME:?Missing PACKAGE_NAME}"
  : "${PACKAGE_TYPE:?Missing PACKAGE_TYPE}"
  : "${LOGIN_TOKEN:?Missing LOGIN_TOKEN}"
  : "${VERSIONS_FILE:?Missing VERSIONS FILE NAME}"
  : "${SIGNATURES_FILE:?Missing SIGNATURES FILE NAME}"
}

# Uses curl to fetch all package versions from GitHub and save to ${VERSIONS_FILE}.
fetch_versions() {
  curl -sSfL \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${LOGIN_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/orgs/${ORG}/packages/${PACKAGE_TYPE}/${PACKAGE_NAME}/versions" > "${VERSIONS_FILE}"
}

# Builds a newline-separated string of all version names in ${VERSIONS_FILE}.
get_all_names() {
  jq -r '.[].name' "${VERSIONS_FILE}"
}

# Helper function to print the signature SHA for a given full_tag
print_sig_sha() {
  local full_tag="$1"
  sig_sha=$(jq -r --arg t "$full_tag" '.[] | select(.metadata.container.tags[]? == $t) | .name' "${VERSIONS_FILE}")
  echo -e "\033[1m$ sig_sha\033[0m"
}

# Loops over entries and prints dangling signatures.
scan_for_dangling_signatures() {
  local all_names
  all_names=$(get_all_names)
  local show_no_sig_tags="${SHOW_NO_SIG_TAGS:-false}"
  local show_assigned_sig_tags="${SHOW_ASSIGNED_SIG_TAGS:-true}"
  while read -r entry; do
    full_tag=$(jq -r '.tags[]? | select(test("^sha256-.*\\.sig$"))' <<<"$entry")
    if [[ -z "$full_tag" ]]; then
      if [[ "$show_no_sig_tags" == "true" ]]; then
        echo "-----------------"
        echo -e "\033[33mNo signature tag found\033[0m"
        echo "-----------------"
        echo ""
      fi
      continue
    fi

    tag=${full_tag/sha256-/sha256:}
    tag=${tag%.sig}
    tag_name=$(jq -r '.name' <<<"$entry")

    if [[ -n "$tag" ]] && ! grep -Fqx "$tag" <<<"$all_names"; then
      echo "-----------------"
      echo "Signature: $full_tag"
      echo "Related Tag: $tag"
      echo "Tag Name: $tag_name"
      echo -e "Status: \033[31mORPHANED SIGNATURE ✗\033[0m"
      echo -e "\033[1mDangling Sig to delete:\033[0m $full_tag"
      print_sig_sha "$full_tag"
      # Find version ID for the signature to delete
      version_id=$(jq -r --arg t "$full_tag" '.[] | select(.metadata.container.tags[]? == $t) | .id' "${VERSIONS_FILE}")
      if [[ -n "$version_id" && "$version_id" != "null" ]]; then
        curl -sSfL \
          -X DELETE \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer ${LOGIN_TOKEN}" \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          "https://api.github.com/orgs/${ORG}/packages/${PACKAGE_TYPE}/${PACKAGE_NAME}/versions/${version_id}"
        echo "Deleted signature: $full_tag (version_id: $version_id)"
      else
        echo "Could not find version ID for signature $full_tag. Skipping deletion."
      fi
      echo "-----------------"
      echo ""
    else
      if [[ "$show_assigned_sig_tags" == "true" ]]; then
        echo "-----------------"
        echo "Signature: $full_tag"
        echo "Related Tag: $tag"
        echo "Tag Name: $tag_name"
        echo -e "Status: \033[32mSIGNATURE ASSIGNED TO IMAGE ✅\033[0m"
        jq -r '.name' <<<"$entry"
        echo "-----------------"
        echo ""
      fi
    fi
  done < <(jq -cr '.[] | {name, tags: (.metadata.container.tags // [])}' "${VERSIONS_FILE}")
}

# Main execution sequence
check_env_vars
fetch_versions
scan_for_dangling_signatures

echo "🏁 Registry cleanup completed."