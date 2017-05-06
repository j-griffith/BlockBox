#!/usr/bin/python

import json
from subprocess import check_call, check_output
import sys


import brick_cinderclient_ext
from cinderclient import client
from cinderclient.contrib import noauth
from keystoneauth1 import loading
from keystoneauth1 import session


def _init_client():
    bypass_url = "http://127.0.0.1:8776/v3"
    project_id = "cinderflex"
    auth_plugin = noauth.CinderNoAuthPlugin('kubernetes',
                                            project_id,
                                            None,
                                            bypass_url)

    loader = loading.get_plugin_loader('noauth')
    auth = loader.load_from_options(endpoint=bypass_url,
                                    user_id="kubernetes",
                                    project_id=project_id)
    sess = session.Session(auth=auth)

    return client.Client(
        3, 'password', 'kubernetes', bypass_url,
        tenant_id='cinderflex',
        bypass_url=bypass_url,
        auth_plugin=auth_plugin,
        session=sess, extensions=[brick_cinderclient_ext])


def _find_id_by_device(device):
    c = _init_client()
    vols = c.volumes.list()
    attached_vols = [v for v in vols if v.status == 'in-use']
    for av in attached_vols:
        if device in av.metadata.get('device', ''):
            return av.id


def _attach(json_params, nodename):
    c = _init_client()
    params = json.loads(json_params)
    volid = params.get('volumeID', None)
    if not volid:
        sys.stderr.write('{"status": "Failure", "message": "Missing volumeID"}')
        sys.exit(1)

    status = c.volumes.get(volid).status
    if 'available' not in status:
        sys.stderr.write(
            '{"status": "Failure", "message": "invalid volume status for attach"}')
        sys.exit(1)

    attach_info = c.brick_local_volume_management.attach(volid, nodename)
    device_meta = {"device": attach_info['path']}
    c.volumes.set_metadata(volid, device_meta)
    print(json.dumps({'status': 'Success', 'device': attach_info['path']}))
    sys.exit(0)


def _detach(mount_device, nodename):
    volid = _find_id_by_device(mount_device)
    c = _init_client()
    c.brick_local_volume_management.detach(volid)
    print(json.dumps({'status': 'Success'}))
    sys.exit(0)


def _mountdevice(mount_dir, device, json_params):
    existing_fs = None
    params = json.loads(json_params)
    fs_type = params.get('["kubernetes.io/fsType"]', 'ext4')
    cmd = ["blkid", "-o", "udev", device]
    try:
        out = check_output(cmd)
    except Exception:
        sys.exit(1)

    for l in out.split("\n"):
        if 'ID_FS_TYPE' in l:
            existing_fs = l.split('=')[1]
            break

    if not existing_fs:
        if fs_type in ['ext4', 'xfs']:
            cmd = ["mkfs", "-t", fs_type]
            try:
                check_call(cmd)
            except Exception:
                sys.exit(1)
        else:
            sys.exit(1)

    cmd = ["mdkir", "-p", mount_dir]
    try:
        check_call(cmd)
    except Exception:
        sys.exit(1)

    cmd = ["mount", device, mount_dir]
    try:
        check_call(cmd)
    except Exception:
        sys.exit(1)

    print(json.dumps({'status': 'Success'}))
    sys.exit(0)


def _unmountdevice(mount_path):
    cmd = ["umount", mount_path]
    try:
        check_call(cmd)
    except Exception:
        sys.exit(1)
    print(json.dumps({'status': 'Success'}))
    sys.exit(0)


def _isattached(json_params, nodename):
    params = json.loads(json_params)
    volid = params.get('volumeID', None)
    if not volid:
        sys.stderr.write('{"status": "Failure", "message": "Missing volumeID"}')
        sys.exit(1)

    if 'in-use' in c.volumes.get(volid).status:
        print(json.dumps({'status': 'Success', 'attached': 'true'}))
    else:
        print(json.dumps({'status': 'Success', 'attached': 'false'}))


def usage(prog):
    sys.stderr.write("Invalid usage.  Usage: ")
    sys.stderr.write("\t%s init", prog)
    sys.stderr.write("\t%s attach <json-params> <nodename", prog)
    sys.stderr.write("\t%s detach <mount-device> <nodename>", prog)
    sys.stderr.write("\t%s mountdevice <mount-dir> <mount-device> "
                     "<json-params>", prog)
    sys.stderr.write("\t%s unmountdevice <mount-device>", prog)
    sys.stderr.write("\t%s isattached <json-params> <nodename>", prog)
    sys.exit(1)

if __name__ == "__main__":
    if sys.argv[1] == "init":
        pass
    elif sys.argv[1] == "attach":
        _attach(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "detach":
        _detach(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "mountdevice":
        _mountdevice(sys.argv[2], sys.argv[3], sys.argv[4])
    elif sys.argv[1] == "unmountdevice":
        _unmountdevice(sys.argv[2])
    elif sys.argv[1] == "isattached":
        _isattached(sys.argv[2], sys.argv[3])
    else:
        usage()
