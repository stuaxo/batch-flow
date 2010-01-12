@echo off
cd \usr
if not "%1"=="" if exist %1 cd %1
