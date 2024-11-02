# Receive via $1 repo suffix
debug_commit()
{
  prog_files=("init" "secu" "move" "comb")

  git reset --hard
  make clean
  cp "${PROJECT_FOLDER}/${repo}-${role}-$1/source/candy1_${prog_files[$(expr ${role:4} - 1)]}.s" "${JPROFES}/source/"
  make
  make debug

  echo "Close all debug windows and press any key to continue"
  read  # Pause code, programs are executed to background
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

main()
{
  echo "
************************************************************************************************************************
* Computers course 2024-2025
* Corrections for practical exercise phase 1
************************************************************************************************************************"


  echo -n > "${REPORT}"

  for file in "${PROJECT_FOLDER}"/data/*.json; do
    if [[ -f "${file}" ]]; then
      parse_data "${file}"
      echo "* INFO: debugging test1 from ${repo} role ${role} of student ${name} (${email})"
      debug_commit "test1"
      if [ "${test1}" != "${test2}" ]; then
        debug_commit "test2"
        echo "* INFO: debugging test2 from ${repo} role ${role} of student ${name} (${email})"
      fi
    fi
  done

  # End with read to avoid the terminal screen disappear
  echo "Press any key to continue"
  read
}


export PROJECT_FOLDER
PROJECT_FOLDER="$(cd "$(dirname "$(realpath "$0")")/.." &>/dev/null && pwd)"

export JPROFES
JPROFES="${PROJECT_FOLDER}/test/JPprofes"
# Use as WD the JProfes repo
cd "${JPROFES}" || exit 2

REPORT="${PROJECT_FOLDER}/out/report_debug.txt"

main "$@"