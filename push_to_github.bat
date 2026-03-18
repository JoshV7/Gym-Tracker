@echo off
:: ══════════════════════════════════════════════
::  Gym Tracker — Auto Push to GitHub Pages
::  Drop this .bat file next to gym_tracker_v5.html
::  Double-click to deploy. That's it.
:: ══════════════════════════════════════════════

setlocal

:: ── CONFIG — edit these two lines ──────────────
set REPO_DIR=%~dp0
set COMMIT_MSG=Update gym tracker %DATE% %TIME%
:: ───────────────────────────────────────────────

echo.
echo  GYM TRACKER — DEPLOY TO GITHUB PAGES
echo  ======================================

:: Check git is installed
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo  ERROR: Git is not installed or not in PATH.
    echo  Download from https://git-scm.com/download/win
    pause
    exit /b 1
)

:: Move to repo directory
cd /d "%REPO_DIR%"

:: Check this is actually a git repo
if not exist ".git" (
    echo  ERROR: No .git folder found in %REPO_DIR%
    echo  Make sure this .bat file is in your gym-tracker repo folder.
    pause
    exit /b 1
)

:: Check the HTML file exists
if not exist "index.html" (
    echo  WARNING: index.html not found.
    echo  Rename gym_tracker_v5.html to index.html first,
    echo  or copy it as index.html in this folder.
    pause
    exit /b 1
)

:: Stage all changes
echo.
echo  Staging changes...
git add -A

:: Check if there's anything to commit
git diff --cached --quiet
if %errorlevel% equ 0 (
    echo  Nothing to commit — file unchanged since last push.
    echo.
    pause
    exit /b 0
)

:: Commit
echo  Committing...
git commit -m "%COMMIT_MSG%"
if %errorlevel% neq 0 (
    echo  ERROR: Commit failed.
    pause
    exit /b 1
)

:: Push
echo  Pushing to GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo.
    echo  Push failed. Possible causes:
    echo    - Not logged into GitHub (run: git credential-manager)
    echo    - Wrong branch name (try editing 'main' to 'master' in this file)
    echo    - No internet connection
    pause
    exit /b 1
)

echo.
echo  ══════════════════════════════════════
echo   DEPLOYED SUCCESSFULLY
echo   https://joshv7.github.io/gym-tracker
echo  ══════════════════════════════════════
echo.
timeout /t 4 >nul
exit /b 0
