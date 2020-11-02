# GitHub Deploy
This role is meant to reach for a valid `*.git` link to a repository.

## Permission Denied
When building this role, I came accross the following issue
`stat() [] failed (13: Permission denied)`.

### The Fix
Nginx operates within the directory, so if you can't `cd` to that directory from
the nginx user then it will fail (as does the `stat` command in your log). Make
sure the `www-data` can `cd` all the way to the `path/to/project`. You can confirm
that the stat will fail or succeed by running
```bash
sudo -u www-data stat /home/user/projects/server_name
```
In this case probably the `/home/username` directory is the issue here. Usually
`www-data` does not have permissions to `cd` to other users home directories.

The solution was to add a new task to the role :
```ansible
- name: Change file ownership, group and permissions
  file:
    state: directory
    path: "/home/{{ username }}/projects/{{ gd_server_name }}"
    owner: "www-data"
    group: "www-data"
    mode: "u=rwX,g=rX,o=rX"
    recurse: yes
```
Note that `X` is `x` only for folders so this command sets `0755` for folders
and `0644` for files.

This way, `www-data` becomes the owner of the directory and can execute said projet.
Another solution would be to add `www-data` to `user` group and allow it to 
execute said project. I tried this solution but it did not work properly so I moved
to above solution that is working for me. It might not be the cleanest way to do it
and I still have to dig into potential issues of this solution
