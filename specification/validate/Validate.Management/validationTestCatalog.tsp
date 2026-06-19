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
  overallState?: string;

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
  overallState?: string;

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

  @doc("Delete a validation test catalog entry")
  @added(Versions.v2026_05_01_preview)
  delete is ValidationTestsOps.DeleteSync<ValidationTest>;

  @doc("List validation test catalog entries")
  @added(Versions.v2026_05_01_preview)
  list is ValidationTestsOps.List<ValidationTest>;
}

@armResourceOperations(ValidationTestVersion)
@tag("Validation Test Version Interfaces")
@added(Versions.v2026_05_01_preview)
interface ValidationTestVersions {
  @doc("Get a validation test version catalog entry")
  @added(Versions.v2026_05_01_preview)
  get is ArmResourceRead<ValidationTestVersion>;

  @doc("Delete a validation test version catalog entry")
  @added(Versions.v2026_05_01_preview)
  delete is ArmResourceDeleteSync<ValidationTestVersion>;

  @doc("List validation test version catalog entries")
  @added(Versions.v2026_05_01_preview)
  listByParent is ArmResourceListByParent<ValidationTestVersion>;
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

  @doc("Delete a validation test category catalog entry")
  @added(Versions.v2026_05_01_preview)
  delete is ValidationTestCategoriesOps.DeleteSync<ValidationTestCategory>;

  @doc("List validation test category catalog entries")
  @added(Versions.v2026_05_01_preview)
  list is ValidationTestCategoriesOps.List<ValidationTestCategory>;
}
