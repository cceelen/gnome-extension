# Releases

For the maintainer: how to make a release and how to check a file of it.

## Make a release

On the Actions tab, select the workflow "release" and "Run workflow". That is
the only step by hand.

The other steps occur automatically:

- [Release Please](https://github.com/googleapis/release-please) opens the
  release pull request. It has the next version in `version-name` of the two
  `metadata.json` files and the new section of `CHANGELOG.md`, made from the
  commit titles since the last release.
- The pull request merges itself when the checks are green.
- `release.yml` makes the two zips and the source archive (`release-files.yml`),
  attests them, attaches them with their provenance bundles to the draft release
  and publishes the release. The tag is made at that moment. The releases are
  immutable.
- The job `ego` uploads the two zips of the published release to
  extensions.gnome.org with `gnome-extensions upload`, logged in with the
  maintainer's account. A reviewer there approves each version; until then the
  site serves the previous one.

extensions.gnome.org gives each upload its own version number; `version-name`
shows the version of this repository.

If no `fix:` or `feat:` was merged since the last release, the run fails and
says so. Do not push a tag by hand, and do not change the version in the files
by hand.

## Check a released file

```sh
gh attestation verify builtin-screen-rotation@cceelen.github.io.shell-extension.zip \
    --repo cceelen/gnome-extension \
    --signer-workflow cceelen/gnome-extension/.github/workflows/release-files.yml
```

Without the attestation API, with the bundle from the release page: add
`--bundle <file>.intoto.jsonl`.

## Set up the repository

- Secrets: `RELEASE_TOKEN` (a fine-grained token of the maintainer for this
  repository: contents, pull requests and workflows, read and write),
  `CODECOV_TOKEN`, and `CLAUDE_CODE_OAUTH_TOKEN` or `ANTHROPIC_API_KEY` for the
  review.
- An environment `extensions.gnome.org`, with deployment branches limited to
  `main`: the variable `EGO_USER` and the secret `EGO_PASSWORD` of the
  maintainer's account on extensions.gnome.org. The site has no tokens. The
  upload accepts the site's terms of service (`--accept-tos`) for that account.
- Settings: immutable releases; "Allow GitHub Actions to create and approve pull
  requests"; private vulnerability reporting; Dependabot alerts.
- A ruleset on `main` that requires the checks of `ci.yml` and a branch that is
  up to date.
- The Renovate app.
