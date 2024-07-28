# :peanuts::butter: peanut-butter-paste
A GitHub Action to upload specific files to Pastebin and generate a report upon completion.

## Inputs

## `dir_to_upload`

**Required** - The path to the directory you wish to push to pastebin. The action will only interfere with files within this directory. Default `"src/"`.

## `ext_whitelist`

A comma seperated list of accepted file extensions. Default `""`.

## Example usage
Create a workflow within your repo by creating a yaml file in `.github/workflows/`. Make sure you set your [github secret](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) to your [Pastebin](https://pastebin.com/) API key.
```yml
---
name: 'peanut-butter-paste'

on:
  push:
    tags:        
      - '**'

jobs:
  peanut-butter-paste:
    runs-on: 'ubuntu-latest'
    steps:
    - name: 'Checkout code'
      uses: 'actions/checkout@v4'

    - name: 'Paste'
      uses: 'OBlount/peanut-butter-paste@v1'
      with:
        dir_to_upload: 'src/'
        ext_whitelist: 'py,sh,txt'
      env:
        PASTEBIN_API_KEY: ${{ secrets.PASTEBIN_API_KEY }}
```
