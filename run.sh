../jai/bin/jai.exe $1.jai
if [ $? -eq 0 ]
then
    ./$1.exe
else
    echo "Compilation failed, program cannot be run"
fi
