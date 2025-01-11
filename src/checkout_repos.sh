#!/usr/bin/env bash

parse_data()
{
  # Parse data
  name="$(cat "$1" | ${JQ} .name | tr -d "\"")"
  email="$(cat "$1" | ${JQ} .email | tr -d "\"")"
  repo="$(cat "$1" | ${JQ} .repo | tr -d "\"")"
  role="$(cat "$1" | ${JQ} .role | tr -d "\"")"
  tests="$(cat "$1" | ${JQ} .tests | tr -d "\"")"
  fusion="$(cat "$1" | ${JQ} .fusion | tr -d "\"")"
  lab="$(cat "$1" | ${JQ} .lab | tr -d "\"")"
  blocks="$(cat "$1" | ${JQ} .blocs | tr -d "\"")"
}


# Description: Determines if a commit with a certain SHA1 ID has passed or not the deadline
# Argument 1: SHA1 ID of the commit to evaluate.
# Argument 2: Lab of the student who presents this commit (L3,L4, etc.)
# Argument 3: Folder with the repo
check_deadline()
{
  deadlines=()
  deadlines[0]="2024-01-08 18:00:00"
  deadlines[1]="2024-01-08 18:00:00"
  deadlines[2]="2024-01-08 18:00:00"
  deadlines[3]="2024-01-08 18:00:00"
  deadlines[4]="2024-01-08 18:00:00"
  deadlines[5]="2024-01-08 18:00:00"
  deadlines[6]="2024-01-08 18:00:00"
  deadlines[7]="2024-01-08 18:00:00"

  # Capture upload date of first commit
  upload_date="$(cd "$3" && git show -s --format=%ci "$1")"

  # Check deadline limits
  if [[ "${upload_date}" < ${deadlines[$(expr ${2:1} - 1)]} ]]; then
    echo "$1 has been uploaded before deadline"
  else
    echo "$1 has been uploaded after deadline"
  fi
  echo "Upload date: ${upload_date}"
}


# Description: Corrects the computers practical exercise of one student
# $1 SHA ID of the commit to checkout
checkout_fusion()
{
  # Perform clone and checkout code
  rm -rf "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}"
  git clone "${DNI}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}-fusion"
  {
    # shellcheck disable=SC2164
    cd "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}-fusion"
    git checkout "${fusion}"
  }
}

# Description: Corrects the computers practical exercise of one student
# $1 test number
# SHA_ID to checkout
checkout_test()
{
  # Perform clone and checkout code
  rm -rf "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}"
  git clone "${DNI}@${GIT_SERVER}:${repo}" "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}-test$1"
  {
    # shellcheck disable=SC2164
    cd "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}-test$1"
    git checkout "$2"
  }
}


# $1 phase
# $2 call
main()
{
  echo "
************************************************************************************************************************
* Computers course 2024-2025
* Corrections for practical exercise phase 1
************************************************************************************************************************
"
  if [ "$1" == "1" ]; then
    PHASE=1st_phase
  elif [ "$1" == "2" ]; then
    PHASE=2nd_phase
  else
    echo "error arg 1 phase cannot be " + $1
  fi

  if [ "$2" == "1" ]; then
    CALL=1st_phase
  elif [ "$2" == "2" ]; then
    CALL=2nd_phase
  else
    echo "error arg 2 call cannot be " + $2
  fi

  for file in "${PROJECT_FOLDER}/data/${PHASE}/${CALL}/"*.json; do
    if [[ -f "${file}" ]]; then
      parse_data "${file}"
        echo "
      ************************************************************************************************************************
      * Student: ${name} (${email})
      * Role: ${role}
      ************************************************************************************************************************"

      checkout_fusion
      check_deadline ${fusion} ${lab} "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}-fusion"
      # Use jq to extract the 'tests' array and loop through it
      i=0
      for test_value in $(jq -r '.tests[]' < "${file}"); do
        i=$((i + 1))
        checkout_test $1 "${test_value}"
        check_deadline "${test_value}" "${lab}" "${PROJECT_FOLDER}/repos/${PHASE}/${CALL}/${repo}-${role}-test$1"
      done
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
