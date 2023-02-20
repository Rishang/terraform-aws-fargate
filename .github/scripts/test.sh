echo $PWD

echo "************** TESTING EXAMPLES *****************"

TEST_DIR="${TEST_DIR:=examples}"

echo "TEST_DIR: $TEST_DIR"
echo "STACK_NAME: $STACK_NAME"

echo "*************************"

if [ -z "$STACK_NAME" ]; then
    echo "ERROR: STACK_NAME required."
    exit 1
fi

function _tf_apply() {
    terraform plan -out=tfplan.zip -input=false && terraform apply -input=false tfplan.zip
}

function _tf_cleanup() {
    find . -type f  -regex  '.*/terraform.tfstate.*' | xargs rm -f
}

_tf_cleanup

docker-compose up -d && sleep 5
(cd $TEST_DIR/$STACK_NAME && terraform init && _tf_apply)
test_status=$?
sleep 5
docker-compose down -v

_tf_cleanup

exit $test_status
