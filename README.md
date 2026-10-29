# dotfiles

zsh + oh-my-zsh + starship, managed with [chezmoi](https://chezmoi.io). Works on macOS and Linux
(Debian/Ubuntu or Fedora). SSH keys and secrets live in 1Password, never in this repo.

`chezmoi apply` installs:

| Tool | macOS | Linux |
| --- | --- | --- |
| aws, gh, kubectl, starship, … | Homebrew | Homebrew |
| 1Password app + `op` CLI | Homebrew cask | 1Password apt/dnf repo |
| GitHub Copilot CLI (`gh copilot`) | Homebrew cask | `gh.io/copilot-install` |
| claude | `claude.ai/install.sh` | same |
| twg | `teamwork-graph.atlassian.com/cli/install` | same |

## New machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.cache/chezmoi-bootstrap init --apply jschaub30
```

The bootstrap binary is throwaway; Homebrew installs the chezmoi you use afterwards.

It asks for your name, email and 1Password vault (and on Linux, whether this machine runs the
1Password desktop app). The repo is private, so authenticate first (`gh auth login`) or use
`init --apply git@github.com:jschaub30/dotfiles.git` with a forwarded SSH agent.

Then:

1. Open 1Password, sign in, and turn on **Settings → Developer → Use the SSH agent** and
   **Integrate with 1Password CLI**.
2. `twg login` and `gh auth login`.
3. Start a new shell.

The first apply copies any files it replaces to `~/.dotfiles-backup/<timestamp>/`, and moves an
existing `~/.ssh/config` to `~/.ssh/config.d/hosts`.

## One-time: move SSH keys into 1Password

1. In the 1Password app, for each key in `~/.ssh` (`id_ed25519`, `ops.pem`, …):
   **New Item → SSH Key → Add Private Key → Import a Key File**. Save it in the vault you
   chose during `chezmoi init`.
2. `ssh-1password-migrate` lists which keys the agent serves and which are still missing.
3. `ssh-1password-migrate --finalize` changes `IdentityFile` lines in `~/.ssh/config.d/*` to point at the
   `.pub` file, and moves the private keys to `~/.ssh/retired-private-keys/`.
4. `ssh -T git@github.com` and a work host. Once they work, delete `~/.ssh/retired-private-keys/`.

## One-time: move shell secrets into 1Password

`~/.config/op/secrets.env` maps environment variables to 1Password items. `opsecrets` loads them
into the current shell; `atllogin` and `odplogin` call it automatically. Create the items it
expects (vault name as chosen at init):

| Variable | 1Password item | Field |
| --- | --- | --- |
| `VAULT_TOKEN` | Vault Token | credential |
| `ODP_PASSWORD` | ODP Admin | password |
| `ATLASSIAN_API_TOKEN` | Atlassian API Token | credential |

Add more by creating the item and adding a line to `secrets.env` (`chezmoi edit ~/.config/op/secrets.env`).

## Day to day

```sh
chezmoi edit ~/.zshrc     # edit the source, then
chezmoi apply             # write it to $HOME
chezmoi update            # pull this repo and apply
chezmoi cd                # jump to the source repo to commit/push
```

Local-only shell tweaks go in `~/.zshrc.local`; local-only ssh hosts in `~/.ssh/config.d/`.
