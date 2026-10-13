# Why plugins need a scanner

New updates made it easier to get plugins, and they already have a lot of downloads.

There are 3 types:
- **Official**
- **Marketplace**
- **Third-party**

There's no real verification. You get a warning that the plugin can run code, but people can skip it.

Example: we made **bash-guard**, which monitors the commands Claude runs. As a test, we added a `curl` to see if it had access to the outside. It does. That same access is what makes it dangerous if someone uses it for malicious things.

Compared to plugins, skills can be audited by the agent itself, because it reads what they contain. The problem with plugins is that they work at the system level, so the agent can't decide on them.

Auto-update is off by default for third-party plugins. But for some specific tasks, people may need to turn it on. Then, when a new version comes out, it could arrive already infected.

Our security scanner plugin would also need frequent updates, so it could become a target for the same problem.

So a plugin scanner should be a priority, like the one we have for skills.
