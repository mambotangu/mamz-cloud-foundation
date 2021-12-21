#!/bin/bash

destroy_step_7 () {

  terraform -chdir=7-prod destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 7"
    exit 1
  else
    echo "Prod resources destroyed. "
    rm -rf ./7-prod/.terraform*
  fi

  echo "" > ./7-prod/provider.tf
  destroy_step_6;
}

destroy_step_6 () {

  terraform -chdir=6-uat destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 6"
    exit 1
  else
    echo "UAT resources destroyed. "
    rm -rf ./6-uat/.terraform*
  fi

  echo "" > ./6-uat/provider.tf
  destroy_step_5
}

destroy_step_5 () {
  terraform -chdir=5-qa destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 5"
    exit 1
  else
    echo "QA resources destroyed. "
    rm -rf ./5-qa/.terraform*
  fi

  echo "" > ./5-qa/provider.tf
  destroy_step_4
}

destroy_step_4 () {
  terraform -chdir=4-dev destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 4"
    exit 1
  else
    echo "Dev resources destroyed. "
    rm -rf ./4-dev/.terraform*
  fi

  echo "" > ./4-dev/provider.tf
  destroy_step_3
}

destroy_step_3 () {
  terraform -chdir=3-shared destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 3"
    exit 1
  else
    echo "Shared resources destroyed. "
    rm -rf ./3-shared/.terraform*
  fi

  echo "" > ./3-shared/provider.tf
  destroy_step_2
}

destroy_step_2() {
  terraform -chdir=2-organization destroy --auto-approve -var-file=terraform.tfvars;

  if [ $? != 0 ]; then
    echo "Error on step 2"
    exit 1
  else
    echo "Organization resources destroyed. ";
    rm -rf ./2-organization/.terraform*;
  fi

  echo "" > ./2-organization/provider.tf;
  destroy_step_1;
}

destroy_step_1() {

  echo "" > ./1-bootstrap/provider.tf;

  terraform -chdir=1-bootstrap init -force-copy;

  if [ $? != 0 ]; then
    echo "Error on step 1 migrating state";
    exit 1
  else
    echo "Bootstrap state migrated. Destroying resources... ";
  fi

  terraform -chdir=1-bootstrap destroy -var-file=terraform.tfvars --auto-approve;

  if [ $? != 0 ]; then
    echo "Error on step 1";
    exit 1
  else
    echo "Bootstrap resources destroyed. ";
    rm -rf ./1-bootstrap/.terraform*;
    rm -f ./1-bootstrap/terraform.tfstate*
    exit 0
  fi

}

# Determine which step to destroy from
if [ $# == 0 ] || [ $1 == 7 ]; then
  destroy_step_7
fi

if [ $1 == 6 ]; then
  destroy_step_6
fi

if [ $1 == 5 ]; then
  destroy_step_5
fi

if [ $1 == 4 ]; then
  destroy_step_4
fi

if [ $1 == 3 ]; then
  destroy_step_3
fi

if [ $1 == 2 ]; then
  destroy_step_2;
fi

if [ $1 == 1 ]; then
  destroy_step_1
fi