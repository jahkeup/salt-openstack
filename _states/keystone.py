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

def _is_exist(ret_dict):
    if ret_dict.get('comment').find("present") > 0:
        return True
    return False

def tenant_present(name,description=None,enabled=True,users=None):
    changes = {}
    if not users:               # Don't want default [] to carry over.
        users = []

    if not _is_error(_keystone('tenant_get',name=name)):
        comment_string = "Tenant is present"
    else:
        tenant = _keystone('tenant_create',name,description=description,
                       enabled=enabled)
        comment_string = "Added tenant"
        changes = {'tenant': tenant}
    
    for user in users:
        try:
            name = user.pop('name')
            password = user.pop('password')
            email = user.pop('email')
        except KeyError:
            comment = "Could not create user, double check user's required args."
            return _changelog(name,status=False,comment=comment)

        user['tenant_id'] = tenant['id']
        user_result = user_present(name,password,email,**user)
        
        if not _is_exists(user_result):
            if not changes.get('users'):
                comment_string += ", updated users."
                changes['users'] = {}
            changes['users'] = {name: user_result}
        if not comment_string.find("users") > 0:
            comment_string += ", users in correct state."

    return _changelog(name,changes=changes,comment=comment_string)



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

