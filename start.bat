@echo off
rem Check if Docker is installed
where docker >nul 2>&1
if errorlevel 1 (
  echo Docker is not found on your system.
  echo Please install Docker from https://docs.docker.com/get-docker/
  exit /b 1
)

rem Check if Docker Compose is installed
where docker-compose >nul 2>&1
if errorlevel 1 (
  echo Docker Compose is not found on your system.
  echo Please install Docker Compose or ensure it's in your PATH.
  exit /b 1
)

rem Check if tmp/pids directory exists, and delete files if present
if exist "tmp\pids\" (
  del /q /s "tmp\pids\*"
  echo Cleaned up tmp/pids directory.
) else (
  echo Directory tmp/pids does not exist. Skipping cleanup.
)

rem Run Docker Compose up
echo Running docker-compose up...
docker-compose up
if errorlevel 1 (
  echo An error occurred while running docker-compose up:
  exit /b 1
)