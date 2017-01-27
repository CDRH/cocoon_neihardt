#!/bin/sh
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

XML_PATTERN="[A-Za-z].*\.xml"
XSL_FILE="cots2solr.xsl"
SOLR_URL="http://segonku.unl.edu:8080/solr/cots/update"

XML_PATH="../xml"
#XSLT_CP="../../WEB-INF/lib/xslt2.jar"
XSLT_CP="/var/lib/cocoon/WEB-INF/lib/xslt2.jar"
SPECIAL=( )

LOG_DIR=log/
LOG=${LOG_DIR}post.log

# clear the logs
rm -f ./${LOG_DIR}*
touch ${LOG}

FILES=`ls ${XML_PATH} | grep -E "${XML_PATTERN}"`

# make sure the solr folder exists
mkdir -p ${XML_PATH}/solr

# clear the solr folder if the XSLT file has been recently updated
if [ "${XSL_FILE}" -nt "$FILES[0]" ]; then
  rm -f ${XML_PATH}/solr/*
fi

# directly copy any "special" files (e.g., .dtd)
for f in $SPECIAL; do
  if [ ! -e "${XML_PATH}/solr/${f}" ]; then
    cp ${XML_PATH}/${f} ${XML_PATH}/solr/${f}
		fi
done

# now convert and post the transformed files
for f in $FILES; do
		if [ "${XML_PATH}/${f}" -nt "${XML_PATH}/solr/${f}" ];then
		  echo "file ${XML_PATH}/solr/${f} doesn't exist or ${XML_PATH}/${f} is newer..." >> ${LOG}
				echo "converting $f..." >> ${LOG}
    java -cp ${XSLT_CP} net.sf.saxon.Transform -w0 \
        ${XML_PATH}/$f ${XSL_FILE} > ${XML_PATH}/solr/$f 2>> ${LOG}
				echo >> ${LOG}

		fi

  echo Posting file $f to ${SOLR_URL}... >> ${LOG}
  echo Result: >> ${LOG}
  curl ${SOLR_URL} --data-binary @${XML_PATH}/solr/$f \
      -H 'Content-type:text/xml; charset=utf-8' >> ${LOG} 2> /dev/null
  echo >> ${LOG}
done

# send the commit command to make sure all the changes are flushed and visible
echo Committing solr results... >> ${LOG}
curl ${SOLR_URL} --data-binary '<commit />' \
    -H 'Content-type:text/xml; charset=utf-8' >> ${LOG} 2> /dev/null
echo "" >> ${LOG}
