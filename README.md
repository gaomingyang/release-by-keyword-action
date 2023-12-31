# release-by-keyword-action

A GitHub Action to Create Releases Based on a Keyword
The Keyword Releaser will create a release based on the keyword specified in the arguments.

# Environment Variables
- `GITHUB_TOKEN` - _Required_ Allows the Action to authenticte with the GitHub API to create the release.

# Arguments
- _Required_ - A single keyword.  If the keyword is found in a commit message, a release will be created.  Although case is ignored, it's suggested to use a unique, uppercase string like `FIXED`, `READY_TO_RELEASE`, or maybe even `PINEAPPLE`.

# Examples
Here's an example workflow that uses the Keyword Releaser action.  The workflow is triggered by a `PUSH` event and looks for the keyword `"FIXED"`.

```
name: keyword-releaser

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: gaomingyang/release-by-keyword-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        args: 'RELEASE'
```

如果提示：
{
"message": "Resource not accessible by integration",
"documentation_url": "https://docs.github.com/rest/releases/releases#create-a-release"
}
需要在当前代码库的setting中，找到Code and automation -> Actions->General.页面底部，勾选read and write,
勾选allow git hub actions to create and approve pull requests.
然后save


后面可以扩展支持：
手动传入tag_name