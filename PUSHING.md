# Pushing changes to GitHub

This repository currently has no Git remote configured. To publish commits (e.g., the latest changes such as exposing the registration entity) to GitHub, add the GitHub URL as a remote and push:

```bash
git remote add origin <GITHUB_REPO_URL>
git push -u origin work
```

If a remote already exists but points to a different URL, update it instead:

```bash
git remote set-url origin <GITHUB_REPO_URL>
git push
```

Use `git status -sb` to confirm the working tree is clean before pushing, and `git log --oneline` to verify the commits you expect to publish.
