main()
{
  curl -L https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 -o "${PROJECT_FOLDER}/lib/jq-linux-amd64"
  curl -L https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-windows-amd64.exe -o "${PROJECT_FOLDER}/lib/jq-windows-amd64.exe"
}

export PROJECT_FOLDER
PROJECT_FOLDER="$(cd "$(dirname "$(realpath "$0")")/.." &>/dev/null && pwd)"
JQ_VERSION=1.7.1

main "$@"