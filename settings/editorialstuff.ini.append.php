<?php /* #?ini charset="utf-8"?

[AvailableFactories]
Identifiers[]
Identifiers[]=offer
Identifiers[]=request
Identifiers[]=private_organization

[offer]
Name=Offers
ClassName=OfferFactory
ClassIdentifier=offer
CreationRepositoryNode=8830
CreationButtonText=Create new offer
RepositoryNodes[]
AttributeIdentifiers[]
StateGroup=offer
States[]
States[draft]=Draft
States[pending]=Waiting for moderator
States[published]=Published
States[expired]=Expired
Actions[]
NotificationAttributeIdentifiers[]

[request]
Name=Requests
ClassName=RequestFactory
ClassIdentifier=request
CreationRepositoryNode=8831
CreationButtonText=Create new request
RepositoryNodes[]
AttributeIdentifiers[]
StateGroup=request
States[]
States[draft]=Draft
States[pending]=Waiting for moderator
States[published]=Published
States[expired]=Expired
Actions[]
NotificationAttributeIdentifiers[]

[private_organization]
Name=Organizations
ClassName=OrganizationFactory
ClassIdentifier=private_organization
CreationRepositoryNode=8311
CreationButtonText=Create new organization
RepositoryNodes[]
AttributeIdentifiers[]
StateGroup=organization
States[]
States[pending]=Waiting for moderator
States[published]=Published
States[expired]=Expired
Actions[]
NotificationAttributeIdentifiers[]


*/ ?>