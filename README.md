# SARIF to GitHub Issues container Action

Based on
[container-action-template](https://github.com/actions/container-action), this
repository contains a GitHub Action that creates GitHub issues from SARIF files.
This GitHub Action depends on the Saris-to-Issues toolkit that is in a separate
repository. We tested the following version combinations:

| Sarif-to-Issues Action (this action) | Saris-to-Issues toolkit |
| ------------------------------------ | ----------------------- |
| v0.005.alpha                         | v0.001.alpha            |
| v0.006.alpha                         | v0.003.alpha            |

## References

1. [GitHub Container Action Template](https://github.com/actions/container-action)
1. [Create Actions](https://docs.github.com/en/enterprise-cloud@latest/actions/sharing-automations/creating-actions)
1. [Create a composite action](https://docs.github.com/en/enterprise-cloud@latest/actions/sharing-automations/creating-actions/creating-a-composite-action)
1. [Creating a Docker container action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-docker-container-action)
1. [GitHub Actions: Deprecating save-state and set-output commands](https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/)
