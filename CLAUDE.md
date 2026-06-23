# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository stores MikroTik RouterOS configuration scripts (`.rsc` files) for an LTE6 router. RouterOS scripts use a proprietary scripting language and are applied directly on the router — there is no build step or test runner on the host machine.

## RouterOS Script Basics

- `.rsc` files use MikroTik's RouterOS scripting syntax (not Bash or any standard language)
- Scripts can be exported from a router via `/export` in the RouterOS terminal
- Scripts are applied on a router via `/import filename.rsc` or by pasting into the terminal
- Each line is typically a RouterOS command path (e.g., `/ip address add ...`, `/interface lte set ...`)
- Comments start with `#`
- Variable syntax: `:local myVar value` and `:set myVar newValue`
- Conditionals and loops use `:if`, `:for`, `:foreach`, `:while`

## Workflow

Since RouterOS runs on the router hardware (not this machine), development workflow is:
1. Edit `.rsc` files in this repo
2. Transfer to the router (SSH, FTP, or Winbox file manager)
3. Apply via `/import` on the router or paste sections into the terminal

There are no linters, formatters, or test runners available in this repo.
