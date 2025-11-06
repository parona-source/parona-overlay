
# Personal Gentoo overlay

[![pipeline status](https://gitlab.com/Parona/parona-overlay/badges/master/pipeline.svg)](https://gitlab.com/Parona/parona-overlay/-/commits/master) 

Just a couple ebuilds, quality might be varying but I want to keep it high enough.

## Add the repository

### eselect-repository

https://wiki.gentoo.org/wiki/Eselect/Repository

```
eselect repository enable parona-overlay
```

### Manually

/etc/portage/repos.conf/parona-overlay.conf
```
[parona-overlay]
location = /var/db/repos/parona-overlay
sync-type = git
sync-uri = https://gitlab.com/Parona/parona-overlay
```

## Generating metadata for repositories (recommended)

Here is a simple posthook that you can use which utilises pmaint (from sys-apps/pkgcore) which is a **lot** faster than egencache. To use you would have to copy it into the location and give it executable permissions.

/etc/portage/repo.postsync.d/99-generate-cache
```bash
#!/usr/bin/env bash
# Make it executable (chmod +x) for Portage to process it.
# Requires sys-apps/pkgcore for pmaint

repository_name=${1}
sync_uri=${2}
repository_path=${3}

ret=0

if [ -n "${repository_name}" ]; then
	echo "* In post-repository hook for ${repository_name}"
	echo "** synced from remote repository ${sync_uri}"
	echo "** synced into ${repository_path}"

	# Gentoo, Guru, kde and science come with pregenerated cache but the other repositories usually don't.
	# Generate them to improve performance.
	# https://www.gentoo.org/support/news-items/2025-10-07-cache-enabled-mirrors-removal.html
	if [[ "${repository_name}" != "gentoo" ]] && [[ "${repository_name}" != "guru" ]] && [[ "${repository_name}" != "kde" ]] && [[ "${repository_name}" != "science" ]]
	then
		if ! pmaint regen "${repository_name}" -t $(nproc) --pkg-desc-index --use-local-desc ${PORTAGE_VERBOSE+--verbose}
		then
			echo "!!! pmaint regen failed!"
			ret=1
		fi
	fi
fi

exit "${ret}"
```

[I use this hook myself which also supports pkgcruft but only works for git repos.](https://gitlab.com/Parona/parona-scripts/-/blob/master/portage-hooks/repo.postsync.d/generate-cache.sh)

### To learn more about hooks:

Find the section for repo.postsync.d in [man 5 portage](https://dev.gentoo.org/~zmedico/portage/doc/man/portage.5.html). And you can find an example file in `/usr/share/portage/config/repo.postsync.d/example`.

The wiki briefly mentions postsync.d which works similarily [Handbook:AMD64/Portage/Advanced#Executing_tasks_after_ebuild_repository_syncs](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/Advanced#Executing_tasks_after_ebuild_repository_syncs).

## Long term unkeyworded packages
Also includes ebuilds that I intend to push to ::gentoo (or not), unkeyworded of course.

* app-alternatives/unzip and app-arch/unzip
	- https://github.com/gentoo/gentoo/pull/33998
* net-im/discord and net-im/discord-ptb
	- https://github.com/gentoo/gentoo/pull/36592
* media-sound/spotify
	- Easier to keep up to date locally and it started diverging...
* games-util/nexusmodsapp
	- https://gitlab.com/Parona/parona-overlay/-/issues/2
	- "This is alpha software, meaning it's still very early in development and may have bugs or issues that could break your mod setup. We've done our best to patch up any major problems, but there will always be a few "gotchas" we haven't accounted for." - https://nexus-mods.github.io/NexusMods.App/users/ 
