
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


clone()
{
  # Perform clone and checkout code
  echo "* INFO: Deleting ${PROJECT_FOLDER}/tmp/${repo}-${role}"
  rm -rf "${PROJECT_FOLDER}/tmp/${repo}-${role}"

  # Clone repo
  echo "* INFO: cloning ${repo} into ${PROJECT_FOLDER}/tmp/${repo}-${role}"
  git clone "${GIT_USER}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/tmp/${repo}-${role}"

  # Force git to work in the cloned repo and checkout first test
  echo "* INFO: setting ${PROJECT_FOLDER}/tmp/${repo}-${role} as the current working git tree"
  export GIT_WORK_TREE="${PROJECT_FOLDER}/tmp/${repo}-${role}"

  echo "* INFO: Checking out test1 ${test1}"
  git checkout "${test1}"

  # End function if it is the same test
  if [ "${test1}" == "${test2}" ]; then
    echo "* INFO: test1 ${test1} and ${test2} are the same, ending clone function"
    return
  else
    echo "* INFO: test1 ${test1} and ${test2} are different, cloning again to check out for ${test2}"
  fi

  # Perform clone and checkout code
  echo "* INFO: Checking out test2 ${test2}"
  rm -rf "${PROJECT_FOLDER}/tmp/${repo}-${role}2"

  # Clone repo
  echo "* INFO: cloning ${repo} into ${PROJECT_FOLDER}/tmp/${repo}-${role}2"
  git clone "${GIT_USER}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/tmp/${repo}-${role}2"

  # Force git to work in the cloned repo and checkout first test
  echo "* INFO: setting ${PROJECT_FOLDER}/tmp/${repo}-${role}2 as the current working git tree"
  export GIT_WORK_TREE="${PROJECT_FOLDER}/tmp/${repo}-${role}2"

  echo "* INFO: Checking out test2 ${test2}"
  git checkout "${test2}"
}

# Description: Corrects the computers practical exercise of one student
# Argument 1: Relative or absolute path to the json file that contains the data for the correction
correct_one()
{
  echo "
************************************************************************************************************************
* Student: ${name} (${email})
* Role: ${role}
************************************************************************************************************************"


  #echo   git clone "${GIT_USER}:${GIT_PASSWORD}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/tmp/${repo}-${role}"
  #git clone "https://${GIT_USER}:${GIT_PASSWORD}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/tmp/${repo}-${role}"
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