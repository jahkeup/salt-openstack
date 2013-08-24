'''Manage tenants, services, and users in keystone

Methods supported:

tenant_present:
  - name: tenant1
  - enabled: True
  - description: Tenant 1
user_present:
  - name: tenant1admin
  - password: P@$sWurd!
  - email: coolguy@example.com
  - tenant_id: 1f29d8-349dsb3434-3489d
service_present:
  - name: service_tenant_nova
  - description: service tenant for nova
  - enabled: True

All of these will create the respective item if missing with the
sepecified fields.

*Currently it will not UPDATE the fields* and the dependent fields
 must be '- require'd, they will not be created.

'''

def _keystone(function,*args,**kwargs):
    return __salt__['keystone.' + function](*args,**kwargs)

def _changelog(name,status=True,changes={},comment=""):
    return {
        name: name,
        result: status,
        changes: changes,
        comment: comment
    }
def _is_error(ret_dict):
    if ret_dict.get('Error'):
        return True
    if ret_dict.get('id'):
        return False

def tenant_present(name,description=None,enabled=True):
    tenant = _keystone('tenant_get',name=name)
    
    if not _is_error(tenant):
        return _changelog(name,comment="Tenant is present")
    tenant = _keystone('tenant_create',name,description=description,
                       enabled=enabled)
    return _changelog(name,changes=tenant,comment="Added tenant")

def user_present(name,password,email,tenant_id=None,enabled=True):
    user = _keystone('user_get',name=name)
    if not _is_error(user):
        return _changelog(name,comment="User is present")
    user = _keystone('user_create',name,password,email,tenant_id=tenant_id,
                     enabled=enabled)
    return _changelog(name,changes=user,comment="Added user")

def service_present(name,service_type,id=None,description=None):
    service = _keystone('service_get',name=name,id=id)
    if not _is_error(service):
        return _changelog(name,comment="Service is present")
    service = _keystone('service_create',name,service_type=service_type,
                        description=description)
    return _changelog(name,changes=service,comment="Added service")

