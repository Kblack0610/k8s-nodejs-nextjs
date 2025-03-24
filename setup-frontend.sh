#!/bin/bash
cd frontend
rm -rf *
# Use expect-like approach with echo and pipes
(echo y; echo y; echo n; echo y; echo y; echo y; echo y; echo y) | npx create-next-app@latest .
