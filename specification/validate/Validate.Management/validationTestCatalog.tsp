using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.Validate;

@doc("Validation test catalog entry.")
@tenantResource
model ValidationTest is TrackedResource<ValidationTestProperties> {
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

  @doc("Validation test version.")
  version?: string;

  @doc("Validation test category ids.")
  categoryIds?: string[];

  @doc("Overall state of the validation test.")
  overallState?: string;

  @doc("URI of the test artifact in TestStore.")
  testStoreUri?: string;
}

@doc("Validation test category catalog entry.")
@tenantResource
model ValidationTestCategory is TrackedResource<ValidationTestCategoryProperties> {
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

  @doc("Parent validation test category id.")
  parentCategoryId?: string;
}

@armResourceOperations
interface ValidationTestsOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,

        @path
        @segment("providers")
        @key
        providerNamespace: "Microsoft.Validate",
      },
      {},
      {
        @path
        @segment("validationTests")
        @key
        validationTestName: string,
      },
      ResourceName = "ValidationTests"
    > {}

@armResourceOperations
@tag("Validation Test Interfaces")
interface ValidationTests {
  @doc("Get a validation test catalog entry")
  get is ValidationTestsOps.Read<ValidationTest>;

  @doc("Create or update a validation test catalog entry")
  createOrUpdate is ValidationTestsOps.CreateOrUpdateSync<ValidationTest>;

  @doc("List validation test catalog entries")
  list is ValidationTestsOps.List<ValidationTest>;
}

@armResourceOperations
interface ValidationTestCategoriesOps
  extends Azure.ResourceManager.Legacy.ExtensionOperations<
      {
        ...ApiVersionParameter,

        @path
        @segment("providers")
        @key
        providerNamespace: "Microsoft.Validate",
      },
      {},
      {
        @path
        @segment("validationTestCategories")
        @key
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
  createOrUpdate is ValidationTestCategoriesOps.CreateOrUpdateSync<
    ValidationTestCategory
  >;

  @doc("List validation test category catalog entries")
  list is ValidationTestCategoriesOps.List<ValidationTestCategory>;
}
