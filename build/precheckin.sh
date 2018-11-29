#!/bin/bash -eux

# switch to git repo directory inside container
cd /horizon-bsn

pwd
echo 'git commit is' ${GIT_COMMIT}

tox -e pep8

setup_cfg_modified=`git log -m -1 --name-only --pretty="format:" | grep setup.cfg | wc -l`
if [ ${setup_cfg_modified} -lt 1 ];
  then echo "Update setup.cfg with new version number. Build FAILED";
  exit 1;
else
  echo "setup.cfg updated"; fi
# check the new_version > old_version
echo 'checking if version bump is correct'
git log -m -1 ${GIT_COMMIT} --pretty="format:" -p setup.cfg | grep version | python3 build/is_version_bumped.py

CURR_VERSION=$(awk '/^version/{print $3}' setup.cfg)
SPEC_VERSION=$(awk '/^Version/{print $2}' rhel/python-horizon-bsn.spec)

if [ "$CURR_VERSION" != "$SPEC_VERSION" ];
  then echo "Update python-horizon-bsn.spec with new version number. Build FAILED."
  exit 1;
else
  echo "python-horizon-bsn.spec updated correctly"; fi
