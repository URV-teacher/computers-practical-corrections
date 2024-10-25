
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

  echo "
************************************************************************************************************************
* Student: ${name} (${email})
* Role: ${role}
************************************************************************************************************************"

  # Perform clone and checkout code
  git clone "${DNI}@${GIT_SERVER}:${repository}" "${PROJECT_FOLDER}/tmp/${repository}-${role}"

  # Force git to work in the cloned repo
  export GIT_DIR="${PROJECT_FOLDER}/tmp/${repository}-${role}/.git"
  export GIT_WORK_TREE="${PROJECT_FOLDER}/tmp/${repository}-${role}/.git"

  git show -s --format=%ci ${test1}
}


main()
{
  echo "
************************************************************************************************************************
* Computers course 2024-2025
* Corrections for practical exercise phase 1
************************************************************************************************************************"

  for file in "${PROJECT_FOLDER}"/data/*.json; do
    if [[ -f "${file}" ]]; then
      correct_one "${file}"
    fi
  done


  # End with read to avoid the terminal screen disappear
  echo "Press any key to continue"
  read
}


export PROJECT_FOLDER
PROJECT_FOLDER="$(cd "$(dirname "$(realpath "$0")")/.." &>/dev/null && pwd)"

JQ="${PROJECT_FOLDER}\lib\jq-windows-amd64.exe"
GIT_SERVER="git.deim.urv.cat"

source "${PROJECT_FOLDER}/.env"

main "$@"