: @gpyl
:
: Generic python launch.
:
: Run a python program in the same folder as this batch file, with the same basename.
:
: For documentation check the python script with the same name.
:
@python %~d0%~p0\%~n0.py %*
