#!/usr/bin/env bash

PREFIX="/net/cvcfs/storage/cvcfs-admin/scripts"

${PREFIX}/check-toplevel-files.sh
${PREFIX}/check-toplevel-dirs.sh
${PREFIX}/check-for-trash.sh
${PREFIX}/report-disk-usage.sh
