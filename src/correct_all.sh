
# Description: Corrects the computers practical exercise of one student
# Argument 1: Relative or absolute path to the json file that contains the data for the correction
correct_one()
{
  # Parse data
  name="$(cat "$1" | ${JQ} .name | tr -d "\"")"
  email="$(cat "$1" | ${JQ} .email | tr -d "\"")"
  repository="$(cat "$1" | ${JQ} .repository | tr -d "\"")"
  role="$(cat "$1" | ${JQ} .role | tr -d "\"")"
  test1="$(cat "$1" | ${JQ} .test1 | tr -d "\"")"
  test2="$(cat "$1" | ${JQ} .test2 | tr -d "\"")"
  fusion="$(cat "$1" | ${JQ} .fusion | tr -d "\"")"

  # Perform clone and checkout code
}


main()
{
  correct_one ${PROJECT_FOLDER}/data/examples/example.json

  # End with read to avoid the terminal screen disappear
  echo "Press any key to continue"
  read
}


export PROJECT_FOLDER
PROJECT_FOLDER="$(cd "$(dirname "$(realpath "$0")")/.." &>/dev/null && pwd)"

JQ="${PROJECT_FOLDER}\lib\jq-windows-amd64.exe"

main "$@"