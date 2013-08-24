from salt.modules.keystone import *

HAS_KEYSTONE = False
try:
    from keystoneclient.v2_0 import client
    HAS_KEYSTONE = True
except ImportError:
    pass

def __virtual__():
    '''
    Only load this module if the keystone client can be loaded
    '''
    if HAS_KEYSTONE:
        return 'keystone'

    return False

def tenant_create(name,description=None,enabled=True):
    '''
    Create a tenant

    CLI Examples::

        salt '*' keystone.tenant_create name=tenant1 description='Tenant 1'

    '''

    kstone = auth()
    tenant = kstone.tenants.create(
        name=name,
        description=description,
        enabled=enabled
    )
    return tenant_get(id=tenant.id)

def service_create(name,service_type=None,description=None):
    # We assume that the type is a valid type.
    kstone = auth()
    service = kstone.services.create(
        name = name,
        service_type = service_type,
        description = description
    )
    return service_get(id=service.id)

def endpoint_create(name,service_id,region="RegionOne",publicurl,
                    internalurl,adminurl=None):
    kstone = auth()
    endpoint = kstone.endpoints.create(
        region = region,
        service_id = service_id,
        publicurl = publicurl,
        internalurl = internalurl,
        adminurl = adminurl
    )
    return endpoint
