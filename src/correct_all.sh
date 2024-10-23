
# Description: Corrects the computers practical exercise of one student
# Argument 1: Relative or absolute path to the json file that contains the data for the correction
correct_one()
{
  cat "$1" |
}


main()
{
  # End with read to avoid the terminal screen disappear
  read
}


export PROJECT_FOLDER
PROJECT_FOLDER="$(cd "$(dirname "$(realpath "$0")")/.." &>/dev/null && pwd)"

JQ="${PROJECT_FOLDER}\lib\jq-windows-amd64.exe"

main "$@"