import "../Enums/Enums.tsp";

namespace Microsoft.Migrate;

@doc("Reference to an existing Azure subscription used by the landing zone.")
model ExistingSubscriptionRef {
  @doc("Azure subscription id (GUID).")
  subscriptionId: string;
}

@doc("Platform subscription topology. The concrete shape is selected by the discriminator \"subscriptionModel\".")
@discriminator("subscriptionModel")
model PlatformSubscriptions {
  @doc("Subscription topology model.")
  subscriptionModel: PlatformSubscriptionModel;
}

@doc("Dedicated subscription model: each platform function uses its own subscription.")
model DedicatedPlatformSubscriptions extends PlatformSubscriptions {
  @doc("Discriminator value.")
  subscriptionModel: PlatformSubscriptionModel.Dedicated;

  @doc("Subscription that hosts the identity platform.")
  identity?: ExistingSubscriptionRef;

  @doc("Subscription that hosts the connectivity platform.")
  connectivity?: ExistingSubscriptionRef;

  @doc("Subscription that hosts the management platform.")
  management?: ExistingSubscriptionRef;
}

@doc("Shared subscription model: a single subscription hosts all platform functions.")
model SharedPlatformSubscriptions extends PlatformSubscriptions {
  @doc("Discriminator value.")
  subscriptionModel: PlatformSubscriptionModel.Shared;

  @doc("Subscription that hosts all platform functions.")
  platform: ExistingSubscriptionRef;
}
