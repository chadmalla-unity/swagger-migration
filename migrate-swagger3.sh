#!/bin/bash

FILES_PATTERN=${1:-*.java}

FILES=`find . -name "$FILES_PATTERN"`

echo ''
echo "Migrating Swagger v2 to Swagger v3 OpenAPI annotations"
echo ''

EXPRESSION="s/import io\.swagger\.annotations\.Api;/import io\.swagger\.v3\.oas\.annotations\.OpenAPIDefinition;\nimport io\.swagger\.v3\.oas\.annotations\.tags.Tag;/g;\
s/io\.swagger\.annotations\.ApiOperation;/io\.swagger\.v3\.oas\.annotations\.Operation;/g;\
s/io\.swagger\.annotations\.ApiParam;/io\.swagger\.v3\.oas\.annotations\.Parameter;/g;\
s/io\.swagger\.annotations\.ApiResponse;/io\.swagger\.v3\.oas\.annotations\.responses\.ApiResponse;/g;\
s/io\.swagger\.annotations\.ApiResponses;/io\.swagger\.v3\.oas\.annotations\.responses\.ApiResponses;/g;\
s/io\.swagger\.annotations\.ApiModelProperty;/io\.swagger\.v3\.oas\.annotations\.media.Schema;/g;\
s/io\.swagger\.annotations\.ApiModelProperty;/io\.swagger\.v3\.oas\.annotations\.media\.Schema;/g;\
\
s/@Api$/@OpenAPIDefinition/g;\
s/@Api(value = \"\([^)]*\)\"/@Tag(name = \"\1\"/g;\
s/@Api(\"\([^)]*\)\"/@Tag(name = \"\1\"/g;\
s/@ApiOperation(value = \"\([^,]*\)\",/@Operation(summary = \"\1\",/g;\
s/@ApiOperation(value = /@Operation(summary = /g;\
s/@ApiOperation(/@Operation(summary = /g;\
s/@ApiResponse(code = \([0-9]\{3\}\), message = \"\(.*\)\", response = \(.*\.class)\)/@ApiResponse(responseCode = \"\1\", description = \"\2\", content = @Content(schema = @Schema(implementation = \3))/g;\
s/@ApiResponse(code = \([0-9]\{3\}\), message = \"\([^)]*\)\")/@ApiResponse(responseCode = \"\1\", description = \"\2\")/g;\
s/@ApiParam(required = \(.*\), value = \"\([^)]*\)\")/@Parameter(required = \1, description = \"\2\")/g;\
s/@ApiParam(value = \"\(.*\)\", required = \([^)]*\))/@Parameter(required = \2, description = \"\1\")/g;\
s/@ApiParam(\"\([^)]*\)\")/@Parameter(description = \"\1\")/g;\
s/@ApiModelProperty(\"/@Schema(description = \"/g;\
s/@ApiModelProperty(notes/@Schema(description/g;\
s/@ApiModelProperty(value/@Schema(description/g;\
"

for FILE in $FILES
do
    CMD="sed -i -e '${EXPRESSION}' '${FILE}'"
    echo ''
    echo "Migrating ${FILE} ..."
    eval ${CMD}
done

echo ''
echo 'Done!'
echo ''
echo 'Note that if you are using reponse parameter in the @ApiResponse annotation then your'
echo 'codebase, you will need to enable [Add unambiguous imports on the fly] option in your IDE.'
echo 'This is because @Content and @Schema are annotations that are being added for the first time.'
echo ''
echo 'This script is not a complete solution, it does not cover cases where the string is concatenated'
echo 'by a plus sign.'
echo ''
echo 'If your project has annotations not in the script, please slack me to update the script. :)'
