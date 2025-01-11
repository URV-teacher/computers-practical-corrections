#!/bin/bash


export PROJECT_FOLDER
PROJECT_FOLDER="$(cd "$(dirname "$(realpath "$0")")/.." &>/dev/null && pwd)"

source "${PROJECT_FOLDER}/.env"

echo "${SSHPASS}"