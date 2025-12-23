Chapters 1–4

    These chapters run commands on the host system. When restarting, be certain of one thing:

    Procedures performed as the root user after Section 2.4 must have the LFS environment variable set FOR THE ROOT USER.

Chapters 5–6

    The /mnt/lfs partition must be mounted.

    These two chapters must be done as user lfs. A su - lfs command must be issued before performing any task in these chapters. If you don't do that, you are at risk of installing packages to the host, and potentially rendering it unusable.

    The procedures in General Compilation Instructions are critical. If there is any doubt a package has been installed correctly, ensure the previously expanded tarball has been removed, then re-extract the package, and complete all the instructions in that section.

Chapters 7–10

    The /mnt/lfs partition must be mounted.

    A few operations, from “Preparing Virtual Kernel File Systems” to “Entering the Chroot Environment,” must be done as the root user, with the LFS environment variable set for the root user.

    When entering chroot, the LFS environment variable must be set for root. The LFS variable is not used after the chroot environment has been entered.

    The virtual file systems must be mounted. This can be done before or after entering chroot by changing to a host virtual terminal and, as root, running the commands in Section 7.3.1, “Mounting and Populating /dev” and Section 7.3.2, “Mounting Virtual Kernel File Systems.”
