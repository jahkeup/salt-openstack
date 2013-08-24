HAS_KEYSTONE = False
try:
    from keystoneclient.v2_0 import client
    HAS_KEYSTONE = True
except ImportError:
    pass
