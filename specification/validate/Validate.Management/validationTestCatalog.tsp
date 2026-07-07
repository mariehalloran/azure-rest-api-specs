using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
using Azure.ResourceManager;

namespace Microsoft.Validate;

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

@doc("Common list query parameters for validation catalog operations.")
model ValidationCatalogListQueryParameters {
  @doc("The number of items to return in the current page.")
  @query("$top")
  @added(Versions.v2026_07_01_preview)
  @minValue(1)
  top?: int32;

  @doc("The number of items to skip before starting to collect the result set.")
  @query("$skip")
  @added(Versions.v2026_07_01_preview)
  @minValue(0)
  skip?: int32;

  @doc("The maximum number of items to return in each page.")
  @query("maxpagesize")
  @added(Versions.v2026_07_01_preview)
  @minValue(1)
  maxpagesize?: int32;

  @doc("Order-by expression to sort the returned items.")
  @query("$orderby")
  @added(Versions.v2026_07_01_preview)
  orderby?: string;

  @doc("Filter expression used to constrain the returned items.")
  @query("$filter")
  @added(Versions.v2026_07_01_preview)
  filter?: string;

  @doc("Filter by audience visibility.")
  @query("audience")
  @added(Versions.v2026_07_01_preview)
  audience?: CatalogAudience;
}

@doc("Validation test catalog entry.")
@tenantResource
@added(Versions.v2026_05_01_preview)
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

  @doc("Validation test category ids.")
  categoryIds?: string[];

  @doc("Overall state of the validation test.")
  @typeChangedFrom(Versions.v2026_07_01_preview, string)
  overallState?: ValidationTestOverallState;

  @doc("Owners of the validation test definition.")
  @added(Versions.v2026_07_01_preview)
  owners?: string[];

  @doc("Declared input contract for this validation test.")
  @added(Versions.v2026_07_01_preview)
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

  @doc("Validation test category ids.")
  categoryIds?: string[];

  @doc("Overall state of the validation test.")
  @typeChangedFrom(Versions.v2026_07_01_preview, string)
  overallState?: ValidationTestOverallState;

  @doc("Owners of the validation test version definition.")
  @added(Versions.v2026_07_01_preview)
  owners?: string[];

  @doc("Declared input contract for this validation test version.")
  @added(Versions.v2026_07_01_preview)
  inputs?: ValidationTestInput[];

  @doc("SHA-256 hash of the version content used for integrity and deduplication.")
  @added(Versions.v2026_07_01_preview)
  @pattern("^[A-Fa-f0-9]{64}$")
  contentHash?: string;

  @doc("URI of the test artifact in TestStore.")
  testStoreUri?: string;
}

@doc("Validation test version catalog entry.")
@tenantResource
@parentResource(ValidationTest)
@added(Versions.v2026_05_01_preview)
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
@added(Versions.v2026_05_01_preview)
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
  @doc("Validation test category description.")
  description?: string;

  @doc("Audience visibility of this validation test category.")
  audience?: CatalogAudience;

  @doc("Provisioning state of the validation test category catalog resource.")
  @visibility(Lifecycle.Read)
  provisioningState?: ResourceProvisioningState;

  @doc("Parent validation test category id.")
  parentCategoryId?: string;
}

@armResourceOperations
@added(Versions.v2026_05_01_preview)
interface ValidationTestsOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,

        @path
        @segment("providers")
        @key
        @doc("The provider namespace.")
        providerNamespace: "Microsoft.Validate",
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
@added(Versions.v2026_05_01_preview)
interface ValidationTests {
  @doc("Get a validation test catalog entry")
  @added(Versions.v2026_05_01_preview)
  get is ValidationTestsOps.Read<ValidationTest>;

  @doc("Create or update a validation test catalog entry and publish a new immutable version snapshot")
  @added(Versions.v2026_05_01_preview)
  createOrUpdate is ValidationTestsOps.CreateOrUpdateSync<ValidationTest>;

  @doc("Update a validation test catalog entry")
  @added(Versions.v2026_07_01_preview)
  @patch(#{ implicitOptionality: false })
  update is ValidationTestsOps.CustomPatchSync<
    ValidationTest,
    PatchModel = ValidationTest
  >;

  @doc("Delete a validation test catalog entry")
  @added(Versions.v2026_05_01_preview)
  delete is ValidationTestsOps.DeleteSync<ValidationTest>;

  @doc("List validation test catalog entries")
  @added(Versions.v2026_05_01_preview)
  list is ValidationTestsOps.List<
    ValidationTest,
    Parameters = ValidationCatalogListQueryParameters
  >;
}

@armResourceOperations(ValidationTestVersion)
@tag("Validation Test Version Interfaces")
@added(Versions.v2026_05_01_preview)
interface ValidationTestVersions {
  @doc("Get a validation test version catalog entry")
  @added(Versions.v2026_05_01_preview)
  get is ArmResourceRead<ValidationTestVersion>;

  @doc("Put a validation test version catalog entry")
  @added(Versions.v2026_05_01_preview)
  put is ArmResourceCreateOrReplaceSync<ValidationTestVersion>;

  @doc("Update a validation test version catalog entry")
  @added(Versions.v2026_07_01_preview)
  @parameterVisibility(Lifecycle.Update)
  update is ArmResourcePatchSync<
    ValidationTestVersion,
    ValidationTestVersionProperties
  >;

  @doc("Delete a validation test version catalog entry")
  @added(Versions.v2026_05_01_preview)
  delete is ArmResourceDeleteSync<ValidationTestVersion>;

  @doc("List validation test version catalog entries")
  @added(Versions.v2026_05_01_preview)
  listByParent is ArmResourceListByParent<
    ValidationTestVersion,
    Parameters = ValidationCatalogListQueryParameters
  >;
}

@armResourceOperations
@added(Versions.v2026_05_01_preview)
interface ValidationTestCategoriesOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,

        @path
        @segment("providers")
        @key
        @doc("The provider namespace.")
        providerNamespace: "Microsoft.Validate",
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
@added(Versions.v2026_05_01_preview)
interface ValidationTestCategories {
  @doc("Get a validation test category catalog entry")
  @added(Versions.v2026_05_01_preview)
  get is ValidationTestCategoriesOps.Read<ValidationTestCategory>;

  @doc("Create or update a validation test category catalog entry")
  @added(Versions.v2026_05_01_preview)
  createOrUpdate is ValidationTestCategoriesOps.CreateOrUpdateSync<ValidationTestCategory>;

  @doc("Update a validation test category catalog entry")
  @added(Versions.v2026_07_01_preview)
  @patch(#{ implicitOptionality: false })
  update is ValidationTestCategoriesOps.CustomPatchSync<
    ValidationTestCategory,
    PatchModel = ValidationTestCategory
  >;

  @doc("Delete a validation test category catalog entry")
  @added(Versions.v2026_05_01_preview)
  delete is ValidationTestCategoriesOps.DeleteSync<ValidationTestCategory>;

  @doc("List validation test category catalog entries")
  @added(Versions.v2026_05_01_preview)
  list is ValidationTestCategoriesOps.List<
    ValidationTestCategory,
    Parameters = ValidationCatalogListQueryParameters
  >;
}
