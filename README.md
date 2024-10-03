# SARIF to GitHub Issues Container Action

Based on
[container-action-template](https://github.com/actions/container-action), this
repository contains a GitHub Action that creates GitHub issues from SARIF files.
This GitHub Action depends on the Saris-to-Issues toolkit that is in a
[separate repository](../GhIssuesFromSarif). We tested the following version
combinations:

| Sarif-to-Issues Action (this action) | Saris-to-Issues toolkit |
| ------------------------------------ | ----------------------- |
| v0.005.alpha                         | v0.001.alpha            |
| v0.006.alpha                         | v0.003.alpha            |
| v0.007.alpha                         | v0.003.alpha            |
