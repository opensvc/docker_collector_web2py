#!/bin/bash

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]]
then
  echo "Begin of docker-entrypoint.d scripts execution"
  /bin/run-parts --verbose "$DIR"
  echo "End of docker-entrypoint.d scripts execution"
fi

exec "$@"
