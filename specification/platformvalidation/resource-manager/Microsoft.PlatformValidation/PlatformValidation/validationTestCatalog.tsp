using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.PlatformValidation;

@doc("Audience visibility of a published catalog item.")
union CatalogAudience {
  @doc("Visible to all customers, including 1P and 3P callers.")
  Public: "Public",

  @doc("Visible only to authorized internal 1P callers.")
  Internal: "Internal",

  string,
}

@doc("The overall state of a validation test or test version.")
union ValidationTestOverallState {
  @doc("The validation test definition is in draft state.")
  Draft: "Draft",

  @doc("The validation test definition is active.")
  Active: "Active",

  @doc("The validation test definition is published.")
  Published: "Published",

  @doc("The validation test definition is disabled.")
  Disabled: "Disabled",

  string,
}

@doc("Supported data types for a declared test input.")
union ValidationTestInputDataType {
  @doc("String input value.")
  String: "String",

  @doc("Integer input value.")
  Integer: "Integer",

  @doc("Numeric input value.")
  Number: "Number",

  @doc("Boolean input value.")
  Boolean: "Boolean",

  @doc("Object input value.")
  Object: "Object",

  @doc("Array input value.")
  Array: "Array",

  string,
}

@doc("Declared contract for a validation test input parameter.")
model ValidationTestInputDefinition {
  @doc("Description of the declared input parameter.")
  description?: string;

  @doc("The data type expected for this input parameter.")
  type?: ValidationTestInputDataType;

  @doc("Whether this input parameter is required.")
  required?: boolean;

  @doc("Optional default value to use when input is not provided.")
  defaultValue?: string;

  @doc("Allowed values for this input parameter.")
  allowedValues?: string[];
}

@doc("A named declared input parameter for a validation test contract.")
model ValidationTestInput {
  @doc("The input parameter name.")
  name: string;

  @doc("The declared contract for this input parameter.")
  definition: ValidationTestInputDefinition;
}

@doc("""
  Common list query parameters for validation catalog operations. Supports OData
  filtering on fields such as `categoryIds` and `audience`, e.g.
  `$filter=audience eq 'Public'`.
  """)
model ValidationCatalogListQueryParameters {
  @doc("Filter expression used to constrain the returned items.")
  @query("$filter")
  filter?: string;
}

@doc("Validation test catalog entry.")
@tenantResource
model ValidationTest is ProxyResource<ValidationTestProperties> {
  ...ResourceNameParameter<
    Resource = ValidationTest,
    KeyName = "validationTestName",
    SegmentName = "validationTests",
    NamePattern = "^[a-zA-Z0-9-]{1,90}$"
  >;
}

@doc("Validation test catalog properties.")
model ValidationTestProperties {
  @doc("Validation test description.")
  description?: string;

  @doc("Audience visibility of this validation test.")
  audience?: CatalogAudience;

  @doc("Provisioning state of the validation test catalog resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("The names of the validation test categories (ValidationTestCategory resource names, not ARM resource IDs) associated with this test.")
  categoryIds?: string[];

  @doc("Overall state of the validation test.")
  overallState?: ValidationTestOverallState;

  @doc("Owners of the validation test definition.")
  owners?: string[];

  @doc("Declared input contract for this validation test.")
  inputs?: ValidationTestInput[];

  @doc("URI of the test artifact in TestStore.")
  testStoreUri?: string;

  @doc("The resource ID of the current immutable version snapshot.")
  @visibility(Lifecycle.Read)
  currentVersion?: string;

  @doc("The resource ID of the latest published version snapshot.")
  @visibility(Lifecycle.Read)
  latestPublishedVersion?: string;

  @doc("Timestamp of the last version publication.")
  @visibility(Lifecycle.Read)
  lastPublishedAt?: utcDateTime;
}

@doc("Validation test version catalog properties.")
model ValidationTestVersionProperties {
  @doc("Validation test description.")
  description?: string;

  @doc("Audience visibility of this validation test version.")
  audience?: CatalogAudience;

  @doc("Provisioning state of the validation test version catalog resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("The names of the validation test categories (ValidationTestCategory resource names, not ARM resource IDs) associated with this test version.")
  categoryIds?: string[];

  @doc("Overall state of the validation test.")
  overallState?: ValidationTestOverallState;

  @doc("Owners of the validation test version definition.")
  owners?: string[];

  @doc("Declared input contract for this validation test version.")
  inputs?: ValidationTestInput[];

  @doc("SHA-256 hash of the version content used for integrity and deduplication.")
  @pattern("^[A-Fa-f0-9]{64}$")
  contentHash?: string;

  @doc("URI of the test artifact in TestStore.")
  testStoreUri?: string;
}

@doc("Validation test version catalog entry.")
@tenantResource
@parentResource(ValidationTest)
model ValidationTestVersion is ProxyResource<ValidationTestVersionProperties> {
  ...ResourceNameParameter<
    Resource = ValidationTestVersion,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = "^[a-zA-Z0-9._-]{1,64}$"
  >;
}

@doc("Validation test category catalog entry.")
@tenantResource
model ValidationTestCategory
  is ProxyResource<ValidationTestCategoryProperties> {
  ...ResourceNameParameter<
    Resource = ValidationTestCategory,
    KeyName = "validationTestCategoryName",
    SegmentName = "validationTestCategories",
    NamePattern = "^[a-zA-Z0-9-]{1,90}$"
  >;
}

@doc("Validation test category properties.")
model ValidationTestCategoryProperties {
  @doc("Display name of the validation test category.")
  displayName?: string;

  @doc("Validation test category description.")
  description?: string;

  @doc("Audience visibility of this validation test category.")
  audience?: CatalogAudience;

  @doc("Provisioning state of the validation test category catalog resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("Parent validation test category id.")
  parentCategoryId?: string;

  @doc("Owners of the validation test category.")
  owners?: string[];
}

@armResourceOperations
interface ValidationTestsOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,

        @path
        @segment("providers")
        @key
        @doc("The provider namespace.")
        providerNamespace: "Microsoft.PlatformValidation",
      },
      {},
      {
        @path
        @segment("validationTests")
        @key
        @doc("The validation test name.")
        @pattern("^[a-zA-Z0-9-]{1,90}$")
        validationTestName: string,
      },
      ResourceName = "ValidationTests"
    > {}

@armResourceOperations
@tag("Validation Test Interfaces")
interface ValidationTests {
  @doc("Get a validation test catalog entry")
  get is ValidationTestsOps.Read<ValidationTest>;

  @doc("Create or update a validation test catalog entry and publish a new immutable version snapshot")
  createOrUpdate is ValidationTestsOps.CreateOrUpdateSync<ValidationTest>;

  @doc("Update a validation test catalog entry")
  @patch(#{ implicitOptionality: false })
  update is ValidationTestsOps.CustomPatchSync<
    ValidationTest,
    PatchModel = ValidationTest
  >;

  @doc("Delete a validation test catalog entry")
  delete is ValidationTestsOps.DeleteSync<ValidationTest>;

  @doc("List validation test catalog entries")
  list is ValidationTestsOps.List<
    ValidationTest,
    Parameters = ValidationCatalogListQueryParameters
  >;
}

@armResourceOperations(ValidationTestVersion)
@tag("Validation Test Version Interfaces")
interface ValidationTestVersions {
  @doc("Get a validation test version catalog entry")
  get is ArmResourceRead<ValidationTestVersion>;

  @doc("Create or update a validation test version catalog entry")
  createOrUpdate is ArmResourceCreateOrReplaceSync<ValidationTestVersion>;

  @doc("Update a validation test version catalog entry")
  @parameterVisibility(Lifecycle.Update)
  update is ArmResourcePatchSync<
    ValidationTestVersion,
    ValidationTestVersionProperties
  >;

  @doc("Delete a validation test version catalog entry")
  delete is ArmResourceDeleteSync<ValidationTestVersion>;

  @doc("List validation test version catalog entries")
  list is ArmResourceListByParent<
    ValidationTestVersion,
    Parameters = ValidationCatalogListQueryParameters
  >;
}

@armResourceOperations
interface ValidationTestCategoriesOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,

        @path
        @segment("providers")
        @key
        @doc("The provider namespace.")
        providerNamespace: "Microsoft.PlatformValidation",
      },
      {},
      {
        @path
        @segment("validationTestCategories")
        @key
        @doc("The validation test category name.")
        @pattern("^[a-zA-Z0-9-]{1,90}$")
        validationTestCategoryName: string,
      },
      ResourceName = "ValidationTestCategories"
    > {}

@armResourceOperations
@tag("Validation Test Category Interfaces")
interface ValidationTestCategories {
  @doc("Get a validation test category catalog entry")
  get is ValidationTestCategoriesOps.Read<ValidationTestCategory>;

  @doc("Create or update a validation test category catalog entry")
  createOrUpdate is ValidationTestCategoriesOps.CreateOrUpdateSync<ValidationTestCategory>;

  @doc("Update a validation test category catalog entry")
  @patch(#{ implicitOptionality: false })
  update is ValidationTestCategoriesOps.CustomPatchSync<
    ValidationTestCategory,
    PatchModel = ValidationTestCategory
  >;

  @doc("Delete a validation test category catalog entry")
  delete is ValidationTestCategoriesOps.DeleteSync<ValidationTestCategory>;

  @doc("List validation test category catalog entries")
  list is ValidationTestCategoriesOps.List<
    ValidationTestCategory,
    Parameters = ValidationCatalogListQueryParameters
  >;
}
