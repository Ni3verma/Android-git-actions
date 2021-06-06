#!/usr/bin/env bash
echo "Running detekt check..."
OUTPUT="/tmp/detekt-$(date +%s)"
./gradlew detekt > $OUTPUT
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  cat $OUTPUT
  rm $OUTPUT
  echo "***********************************************"
  echo "                 Detekt failed                 "
  echo " Please fix the above issues before committing "
  echo "***********************************************"
  exit $EXIT_CODE
fi
rm $OUTPUT
echo "**********detekt passed"

echo "Running ktlint format"
./gradlew ktlintFormat
echo "**********Automatic formatting done"


echo "Running ktlint check"
./gradlew app:ktlintCheck --daemon

status=$?

if [ "$status" = 0 ] ; then
	echo "**********ktlint passed"
else
	echo 1>&2 "* ktlint failed"
	exit 1
fi