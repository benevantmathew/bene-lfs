#!/bin/bash
# ======================================================
#  Script Name: config.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  LFS: 12.4
#  Purpose: Defines Variables
# ======================================================

# --- LFS Directory and Version ---

# LFS: The mount point for the LFS partition. (MANDATORY)
export LFS="/mnt/lfs"

# LFS_VERSION: Used for tracking the build version.
export LFS_VERSION="12.4"

# SRC: The path where all source tarballs are stored.
export SRC="/mnt/lfs/sources"


# --- Toolchain Variables (Chapter 5) ---

# LFS_TGT: The target triplet for the cross-compiler.
# This ensures that all tools compile for the new LFS system.
export LFS_TGT=$(uname -m)-lfs-linux-gnu

# MAKEFLAGS: Optimization to use all available CPU cores for compilation.
# It's usually best to define this in the 'lfs' user's .bashrc
# (as you did in a previous script) rather than here, but you can define it
# here for other utility scripts run as root.
# export MAKEFLAGS="-j$(nproc)"