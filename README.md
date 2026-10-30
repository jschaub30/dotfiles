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

On a Linux account with no password (e.g. `ubuntu` on EC2), set one first: `sudo passwd $USER`.
The install runs `chsh` to make zsh your login shell, and `chsh` prompts for it.

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.cache/chezmoi-bootstrap init --apply jschaub30
```

The bootstrap binary is throwaway; Homebrew installs the chezmoi you use afterwards.

It asks for your name, email and 1Password vault (and on Linux, whether this machine runs the
1Password desktop app).

Then:

1. Start a new shell so zsh, Homebrew and `~/.local/bin` are on your PATH: `exec zsh -l`
   (on Linux, if zsh isn't active yet, log out and back in).
2. Open 1Password, sign in, and turn on **Settings → Developer → Use the SSH agent** and
   **Integrate with 1Password CLI**.
3. `twg login` and `gh auth login`.

The first apply copies any files it replaces to `~/.dotfiles-backup/<timestamp>/`, and moves an
existing `~/.ssh/config` to `~/.ssh/config.d/hosts`.

## Day to day

```sh
chezmoi edit ~/.zshrc     # edit the source, then
chezmoi apply             # write it to $HOME
chezmoi update            # pull this repo and apply
chezmoi cd                # jump to the source repo to commit/push
```

Local-only shell tweaks go in `~/.zshrc.local`; local-only ssh hosts in `~/.ssh/config.d/`.
