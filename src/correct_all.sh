
# Description: Determines if a commit with a certain SHA1 ID has passed or not the deadline
# Argument 1: SHA1 ID of the commit to evaluate.
# Argument 2: Lab of the student who presents this commit.
check_deadline()
{
  deadlines=()
  deadlines[0]="2024-10-28 16:00:00"
  deadlines[1]="2024-10-28 16:00:00"
  deadlines[2]="2024-10-28 16:00:00"
  deadlines[3]="2024-10-28 16:00:00"
  deadlines[4]="2024-10-23 16:00:00"
  deadlines[5]="2024-10-23 16:00:00"
  deadlines[6]="2024-10-23 16:00:00"
  deadlines[7]="2024-10-28 16:00:00"

  # Capture upload date of first commit
  upload_date="$(git show -s --format=%ci $1)"

  # Check deadline limits
  if [[ "${upload_date}" < ${deadlines[$(expr ${2:1} - 1)]} ]]; then
    echo "$1 has been uploaded before deadline"
  else
    echo "$1 has been uploaded after deadline"
  fi
  echo "Upload date: ${upload_date}"

}

parse_data()
{
  # Parse data
  name="$(cat "$1" | ${JQ} .name | tr -d "\"")"
  email="$(cat "$1" | ${JQ} .email | tr -d "\"")"
  repo="$(cat "$1" | ${JQ} .repo | tr -d "\"")"
  role="$(cat "$1" | ${JQ} .role | tr -d "\"")"
  test1="$(cat "$1" | ${JQ} .test1 | tr -d "\"")"
  test2="$(cat "$1" | ${JQ} .test2 | tr -d "\"")"
  fusion="$(cat "$1" | ${JQ} .fusion | tr -d "\"")"
  lab="$(cat "$1" | ${JQ} .lab | tr -d "\"")"
}

# This function is idempotent
clone()
{
  # test1
  echo "* INFO: Deleting ${PROJECT_FOLDER}/repos/${repo}-${role}-test1, if exists"
  rm -rf "${PROJECT_FOLDER}/repos/${repo}-${role}-test1"

  echo "* INFO: cloning ${repo} into ${PROJECT_FOLDER}/repos/${repo}-${role}-test1"
  git clone "${GIT_USER}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/repos/${repo}-${role}-test1"

  {
    echo "* INFO: setting ${PROJECT_FOLDER}/repos/${repo}-${role}-test1 as the current working git tree"
    cd "${PROJECT_FOLDER}/repos/${repo}-${role}-test1" || exit 1

    echo "* INFO: Checking out test1 ${test1}"
    git checkout "${test1}"
  }

  # fusion
  echo "* INFO: Deleting ${PROJECT_FOLDER}/repos/${repo}-${role}-fusion, if exists"
  rm -rf "${PROJECT_FOLDER}/repos/${repo}-${role}-fusion"

  echo "* INFO: cloning ${repo} into ${PROJECT_FOLDER}/repos/${repo}-${role}-fusion"
  git clone "${GIT_USER}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/repos/${repo}-${role}-fusion"

  {
    echo "* INFO: setting ${PROJECT_FOLDER}/repos/${repo}-${role}-fusion as the current working git tree"
    cd "${PROJECT_FOLDER}/repos/${repo}-${role}-fusion" || exit 1

    echo "* INFO: Checking out test1 ${test1}"
    git checkout "${test1}"
  }

  # End function if it is the same test
  if [ "${test1}" == "${test2}" ]; then
    echo "* INFO: test1 ${test1} and ${test2} are the same, ending clone function"
    return
  else
    echo "* INFO: test1 ${test1} and ${test2} are different, cloning again to check out for ${test2}"
  fi

  # test2
  echo "* INFO: Deleting out ${PROJECT_FOLDER}/repos/${repo}-${role}-test2, if exists"
  rm -rf "${PROJECT_FOLDER}/repos/${repo}-${role}-test2"

  echo "* INFO: cloning ${repo} into ${PROJECT_FOLDER}/repos/${repo}-${role}-test2"
  git clone "${GIT_USER}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/repos/${repo}-${role}-test2"

  {
    echo "* INFO: setting ${PROJECT_FOLDER}/repos/${repo}-${role}-test2 as the current working git tree"
    cd "${PROJECT_FOLDER}/repos/${repo}-${role}-test2"  || exit 2

    echo "* INFO: Checking out test2 ${test2}"
    git checkout "${test2}"
  }
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
      parse_data "${file}"
      clone "${file}"
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