"""
State module for ceph

*Requires ceph to be installed and service running.*
"""

def _changeset(name,status,changes,comment):
     return {
        'name': name,
        'result': status,
        'changes': changes,
        'comment': comment
    }
def user_exists(name,permissions):
    pass
