# Swagger 2 to Swagger 3 OpenAPI 3 Annotations Migration

## How to use

1. Download the `migrate-swagger` script to the root of your project
1. The script will only scan for `*.java` files in your project
1. Once script completes double check by building the application and running it

> Possible breaks maybe if you have a string that is concatenated by `+` for any of the values that it is trying to migrate

Example:

```java
@ApiResponse(code = 200, message = "hello" +
	"world")

```
At the moment I don't have a pattern to recognize that but may add it later.

## What you should expect

```java
// Original 

package ca.clearly.web.app.catalogue.api;

// other imports
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@RestController
@RequiredArgsConstructor
@RequestMapping(AttributeController.API_CATALOGUE_ATTRIBUTES)
@Api
public class AttributeController {

    @PostMapping
    @ApiOperation("Create an attribute.")
    @ApiResponses({
        @ApiResponse(code = 201, message = "by Cicero, written in 45 BC", response = AttributeResource.class),
        @ApiResponse(code = 400, message = "when an unknown printer took a galley of type and scrambled it to make a type specimen"),
        @ApiResponse(code = 404, message = "software like Aldus PageMaker including. <br/>\nOR<br/>\n Contrary to popular belief, Lorem Ipsum <br/>\nOR<br/>\n Latin words, consectetur")
    })
    @ResponseStatus(code = CREATED)
    public ResponseEntity<Resource<AttributeResource>> createAttribute(
        @ApiParam(required = true, value = "by Cicero, written in 45 BC")
        @RequestBody @Valid AttributeResource attributeResource
    ) {
    	...

    }

    @GetMapping("/{attributeId}")
    @ApiOperation("Retrieve an attribute.")
    @ApiResponses({
        @ApiResponse(code = 200, message = "by Cicero, written in 45 BC"),
        @ApiResponse(code = 404, message = "by Cicero, written in 45 BC")
    })
    public ResponseEntity<Resource<AttributeResource>> getAttributeById(
        @ApiParam(required = true, value = "Attribute id")
        @PathVariable(value = "attributeId") UUID attributeId
    ) {
        ...
    }
}
```

**becomes**

```java
// Migrated

package ca.clearly.web.app.catalogue.api;

// other imports
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@RequiredArgsConstructor
@RequestMapping(AttributeController.API_CATALOGUE_ATTRIBUTES)
@OpenAPIDefinition
public class AttributeController {

    @PostMapping
    @Operation(summary = "Create an attribute.")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "by Cicero, written in 45 BC", content = @Content(schema = @Schema(implementation = AttributeResource.class))),
        @ApiResponse(responseCode = "400", description = "when an unknown printer took a galley of type and scrambled it to make a type specimen"),
        @ApiResponse(responseCode = "404", description = "software like Aldus PageMaker including. <br/>\nOR<br/>\n Contrary to popular belief, Lorem Ipsum<br/>\nOR<br/>\n Latin words, consectetur")
    })
    @ResponseStatus(code = CREATED)
    public ResponseEntity<Resource<AttributeResource>> createAttribute(
        @Parameter(required = true, description = "by Cicero, written in 45 BC")
        @RequestBody @Valid AttributeResource attributeResource
    ) {
        ...

    }

    @GetMapping("/{attributeId}")
    @Operation(summary = "Retrieve an attribute.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "by Cicero, written in 45 BC"),
        @ApiResponse(responseCode = "404", description = "by Cicero, written in 45 BC")
    })
    public ResponseEntity<Resource<AttributeResource>> getAttributeById(
        @Parameter(required = true, description = "Attribute id")
        @PathVariable(value = "attributeId") UUID attributeId
    ) {
        ...
    }
}

```