# SARIF to GitHub Issues container Action

Based on
[container-action-template](https://github.com/actions/container-action), this
repository contains a few GitHub Actions:

1. Action init. The init action is to download the toolkit.
1. Action parsesarif. The parsesarif action parses Sarif files and extract
   relevant content for creating issues, such as GitHub issues. This action
   depends on the successful completion of the init action.
1. Action ghissues. The ghissues action creates GitHub issues using the issue
   content extracted by the parsesarif action.
1. The sariftoissues action is the all-in-one action that combines the above
   three.
