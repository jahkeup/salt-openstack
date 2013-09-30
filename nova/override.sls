nova-service-override:
  file.managed:
    - name: /etc/init/nova-compute.override
    - contents: manual