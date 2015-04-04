#!/bin/bash -ex

bin=$(dirname $0)
D=/tmp/$$
mkdir -p $D/src

cp -R $bin/* $D/src
pushd $D/src
  pushd launchd_conf_daemon
    mv org.jenkins-ci.plist $OSX_IDPREFIX.plist
  popd
  pushd launchd_conf_jenkins
    mv org.jenkins-ci.plist $OSX_IDPREFIX.plist
  popd
popd
$BASE/bin/branding.sh $D/src

tar cvzf $D/script.tgz -C $D/src .

java -jar $TARGET/jenkins-cli.jar dist-fork -z $D/script.tgz \
  -f binary/${ARTIFACTNAME}.war="${WAR}" \
  -f build.sh=$bin/build.sh -l osx -F "${OSX}=jenkins.pkg" \
  /bin/bash -ex build.sh binary/${ARTIFACTNAME}.war $VERSION $ARTIFACTNAME "$PRODUCTNAME"
touch ${OSX}
rm -rf $D