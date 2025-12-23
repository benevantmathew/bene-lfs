#!/bin/bash
# ======================================================
#  Script Name: 14_cleaning_after_temp_tools.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  Purpose:
#  Usage: bash ./14_cleaning_after_temp_tools.sh
# ======================================================

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
# rm -rf /tools # deleet it some where down the line for safety