# myserver
Debian webserver deployment for personnal use (Commander League, MtG Association, ...)

## First Steps
Create a venv in this directory
```bash
python3 -m venv webserver
source webserver/bin/activate
pip install ansible
```
Create a `.vault-password-file.txt` in this directory
```bash
touch .vault-password-file.txt
```
Generate a strong password and put it in there.


## Initial Setup
Use the user and password you received by e-mail after your server setup.
```bash
ansible-playbook --user <provided_user> initial.yml -k
```

### Setup Packages
```bash
ansible-playbook setup.yml
```

### Specific Commands
### GitHub Deploy Key
Get the public RSA key from the server:
```bash
ssh krcg.org
$> cd ~/.ssh
$> cat id_rsa.pub
```
And add it to the Deploy Keys (Settings > Deploy Keys) of the Github repository.

#### Discord Token
You need to get the bot token from discord and use `ansible-vault` to encode it:
```bash
ansible-vault encrypt_string '<bot_token>' --name 'DISCORD_TOKEN'
```
Copy the resulting string to `x-bot.yaml` (replace the old `DISCORD_TOKEN` value). You can now deploy:
```bash
ansible-playbook x-bot.yml
```
