# habitat-support

This is what I've been using in development (on my Mac) with Vagrant and VirtualBox. (This repo sits alongside my `habitat` repo.)

## To use it...

First, substitute your GitHub auth token in these places:

  * [config/config_worker.toml](./config/config_worker.toml)
  * [scripts/env.sh](./scripts/env.sh)

And if you happen to have your own origin and keys you'd like to use in development also, change the references to `cnunciato` and associated key names in the [Makefile](./Makefile). (Otherwise, you'll want to delete those lines in the `origins` and `keys` tasks.)

Then, in one tab, build and start the Builder services:

```
make start
```

This should complete with all services running (usually takes about 20 minutes for me), and you should be able to browse to the UI at http://localhost:3000 and sign in, but there won't be any data yet.

> While that's running, if you haven't already, [download a package archive](http://nunciato-shared-files.s3.amazonaws.com/pkgs.zip) and unpack it into `./pkgs`. Vagrant will share the directory into the VM as `/hab/cache/artifacts`

When that finishes and all the services are running, in another tab, run:

```
make load
```

This will create your origin(s), keys, a new project and submit a job for that project. (I'm currently using `linux-headers`, so I know that one works, and I've also used `nginx`, but I can't speak to others specifically.)

This second task takes longer, because it uploads like 600 packages. I usually snapshot the VM after either the second step since it leaves the DB in a good place.
