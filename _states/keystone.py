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

import logging

log = logging.getLogger(__name__)

def _keystone(function,*args,**kwargs):
    return __salt__['keystone.' + function](*args,**kwargs)

def _changelog(name,status=True,changes={},comment=""):
    return {
        'name': name,
        'result': status,
        'changes': changes,
        'comment': comment
    }
def _is_error(ret_dict):
    if ret_dict.get('Error'):
        return True
    if ret_dict.get('id'):
        return False

def _is_exists(ret_dict):
    if ret_dict.get('comment').find("present") > 0:
        return True
    return False
def _and(left={},right={}):
    return dict(left.items() + right.items())

def _argdict_to_dict(arglist):
    result = {}
     
    for item in arglist.items():
        keyname = item[0]
        result[keyname] = {}
        for subdict in item[1]:
            for key in subdict.keys():
                if not result[keyname].get(key):
                    result[keyname][key] = {}
                result[keyname][key] = subdict[key]
    return result

def tenant_present(name,description=None,enabled=True,users=None, **connargs):
    log.debug("will add users: {0}".format(users))
    changes = {}
    if not users:               # Don't want default [] to carry over.
        users = []
    else: 
        users = _argdict_to_dict(users)
    tenant = _keystone('tenant_get',name=name,**connargs)

    if not _is_error(tenant):
        comment_string = "Tenant is present"  
    else:
        tenant = _keystone('tenant_create',name,description=description,
                           enabled=enabled, **connargs)
        comment_string = "Added tenant"
        changes = {'tenant': tenant}

    tenant_id=tenant[name]['id']

    for user in users:
        try:
            user_name = users[user].pop('name')
            password = users[user].pop('password')
            email = users[user].pop('email')
        except KeyError:
            comment = "Could not create user, double check user's required args."
            return _changelog(user_name,status=False,comment=comment)

        user_result = user_present(user_name,password,email,tenant_id=tenant_id,**connargs)
        
        if not _is_exists(user_result):
            if not changes.get('users'):
                comment_string += ", updated users."
                changes['users'] = {}
            changes['users'][user_name] =  user_result
        if not comment_string.find("users") > 0:
            comment_string += ", users in correct state."

    return _changelog(name,changes=changes,comment=comment_string)



def user_present(name,password,email,tenant_id=None,enabled=True, **connargs):
    user = _keystone('user_get',name=name,**connargs)
    if not _is_error(user):
        return _changelog(name,comment="User is present")
    user = _keystone('user_create',name,password,email,tenant_id=tenant_id,
                     enabled=enabled,**connargs)
    return _changelog(name,changes=user,comment="Added user")

def service_present(name,service_type,id=None,description=None, **connargs):
    service = _keystone('service_get',name=name,id=id,**connargs)
    if not _is_error(service):
        return _changelog(name,comment="Service is present")
    service = _keystone('service_create',name,service_type=service_type,
                        description=description,**connargs)
    return _changelog(name,changes=service,comment="Added service")

