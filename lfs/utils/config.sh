#!/bin/bash
# ======================================================
#  Script Name: config.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Defines Variables
# ======================================================

# --- LFS Directory and Version ---

# LFS_VERSION: Used for tracking the build version.
export LFS_VERSION="12.4"

# SRC: The path where all source tarballs are stored.
export SRC="/sources"

# MAKEFLAGS: Optimization to use all available CPU cores for compilation.
# It's usually best to define this in the 'lfs' user's .bashrc
# (as you did in a previous script) rather than here, but you can define it
# here for other utility scripts run as root.
# export MAKEFLAGS="-j$(nproc)"