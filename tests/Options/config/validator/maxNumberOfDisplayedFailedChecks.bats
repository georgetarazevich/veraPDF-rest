#!/usr/bin/env bats

setup() {
    PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." >/dev/null 2>&1 && pwd)"
    load "$PROJECT_ROOT/tools/test_helper/common-setup.bash"
    _common_setup

    docker exec --user=root $DOCKER_CONTAINER rm -rf /opt/verapdf-rest/config/features.xml
    docker exec --user=root $DOCKER_CONTAINER rm -rf /opt/verapdf-rest/config/fixer.xml
    docker exec --user=root $DOCKER_CONTAINER rm -rf /opt/verapdf-rest/config/plugins.xml
    docker exec --user=root $DOCKER_CONTAINER rm -rf /opt/verapdf-rest/config/validator.xml
    docker exec --user=root $DOCKER_CONTAINER rm -rf /opt/verapdf-rest/config/app.xml

    docker cp $BATS_TEST_DIRNAME/maxNumberOfDisplayedFailedChecks/validator.xml $DOCKER_CONTAINER:/opt/verapdf-rest/config/validator.xml

}

teardown() {
    docker cp $DOCKER_CONTAINER:/opt/verapdf-rest/config/validator.xml $BATS_TEST_TMPDIR
    cat $BATS_TEST_TMPDIR/validator.xml >&3 #out to console validator.xml to see options set after test >&3

    echo -e "Done ..." >&3
}

@test "--maxNumberOfDisplayedFailedChecks, Outputs all processed file names, maxNumberOfDisplayedFailedChecks=0" {

    run curl -F "file=@$PROJECT_ROOT/Resources/a.pdf" localhost:8080/api/validate/1b -H "Accept:text/html"
    refute_output --partial '<b>Failed</b>'

    [ "$status" -eq 0 ]
}
