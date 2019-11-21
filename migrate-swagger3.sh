#!/bin/bash

FILES_PATTERN=${1:-*.java}

FILES=`find . -name "$FILES_PATTERN"`

echo ''
echo "Migrating Swagger v2 to Swagger v3 OpenAPI Spec"
echo ''

EXPRESSION="s/io\.swagger\.annotations\.Api;/io\.swagger\.v3\.oas\.annotations\.OpenAPIDefinition;/g;\
s/io\.swagger\.annotations\.ApiOperation;/io\.swagger\.v3\.oas\.annotations\.Operation;/g;\
s/io\.swagger\.annotations\.ApiParam;/io\.swagger\.v3\.oas\.annotations\.Parameter;/g;\
s/io\.swagger\.annotations\.ApiResponse;/io\.swagger\.v3\.oas\.annotations\.responses\.ApiResponse;/g;\
s/io\.swagger\.annotations\.ApiResponses;/io\.swagger\.v3\.oas\.annotations\.responses\.ApiResponses;/g;\
s/io\.swagger\.annotations\.ApiModelProperty;/io\.swagger\.v3\.oas\.annotations\.media.Schema;/g;\
s/io\.swagger\.annotations\.ApiModelProperty;/io\.swagger\.v3\.oas\.annotations\.media\.Schema;/g;\
\
s/@Api$/@OpenAPIDefinition/g;\
s/@ApiOperation(/@Operation(summary = /g;\
s/@ApiResponse(code = \([0-9]\{3\}\), message = \"\(.*\)\", response = \(.*\.class)\)/@ApiResponse(responseCode = \"\1\", description = \"\2\", content = @Content(schema = @Schema(implementation = \3))/g;\
s/@ApiResponse(code = \([0-9]\{3\}\), message = \"\(.*\)\")/@ApiResponse(responseCode = \"\1\", description = \"\2\")/g;\
s/@ApiParam(required = \(.*\), value = \"\(.*\)\")/@Parameter(required = \1, description = \"\2\")/g;\
s/@ApiModelProperty(/@Schema(description = /g;\
"

for FILE in $FILES
do
    echo "Adapting $FILE"
    echo ''
    echo $EXPRESSION
    echo ''
    sed -i "" -e "$EXPRESSION" $FILE
done

echo
echo 'Done!'
echo 'Note that if you are using reponse parameter in the @ApiResponse annotation then your'
echo 'codebase, you will need to trigger organize imports in your IDE to add the imports for'
echo '@Content and @Schema'