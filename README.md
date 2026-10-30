# dotfiles

zsh + oh-my-zsh + starship, managed with [chezmoi](https://chezmoi.io). Works on macOS and Linux
(Debian/Ubuntu or Fedora). SSH keys and secrets live in 1Password, never in this repo.

`chezmoi apply` also installs the CLI tools via Homebrew and vendor installers.

## New machine

- `sudo passwd $USER` (Linux accounts with no password; `chsh` needs one)
- `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.cache/chezmoi-bootstrap init --apply jschaub30`
  (prompts for name, email and 1Password vault)
- Log out
- Log in
- `eval "$(op signin)"`
- `twg login`
- `twg skills install`
- `gh auth login`
- `aws configure sso --use-device-code`

Replaced files are backed up to `~/.dotfiles-backup/<timestamp>/`, and an existing `~/.ssh/config`
moves to `~/.ssh/config.d/hosts`.

## Day to day

```sh
chezmoi edit ~/.zshrc     # edit the source, then
chezmoi apply             # write it to $HOME
chezmoi update            # pull this repo and apply
chezmoi cd                # jump to the source repo to commit/push
```

Local-only shell tweaks go in `~/.zshrc.local`; local-only ssh hosts in `~/.ssh/config.d/`.
