# Author: Remus Flavius TIMBULI
# Assemble programs in one step

                ############   RELEASE DIRECTORY CLEANUP   ############

if [ !Release/ ]; then
  mkdir -m 755 Release
else
  rm -r Release/
  mkdir -m 755 Release
fi


                ################   WORKING DIRECTORY   ################

WORKING_DIRECTORY=${PWD}'/'
RELEASE_NAME=${PWD##*/}
RELEASE_DIRECTORY_PATH=$WORKING_DIRECTORY"Release/"


                 ##################   SOURCE FILES   ##################

find . -type f -not -path "*cmake-build-debug*" -not -path "*private*" -name '*.asm' > file_search
mv file_search Release/
cd Release/

echo -e "Choose assembler architecture:\n1.elf32\n2.elf64"
read assembler_choice

if [ "$assembler_choice" -eq 1 ]; then
     assembler_arch_type="elf32"
elif [ "$assembler_choice" -eq 2 ]; then
     assembler_arch_type="elf64"
else
     $WORKING_DIRECTORY./AssembleMaker.sh
fi

while read line; do
    FILE_NAME=$(basename $WORKING_DIRECTORY${line:1} .asm)
    DIR_NAME=${line%/*}
    FULL_DIR_NAME=$WORKING_DIRECTORY${DIR_NAME:2}
    nasm -f $assembler_arch_type $FULL_DIR_NAME$FILE_NAME.asm -l $FILE_NAME.lst
    mv $FULL_DIR_NAME$FILE_NAME.o $RELEASE_DIRECTORY_PATH
done <file_search
rm file_search


echo -e "Choose architecture:\n1.elf_x86_64\n2.elf32_x86_64\n3.elf_i386\n4.elf_iamcu\n5.i386linux\n6.elf_l1om\n7.elf_klom\n8.i386pep\n9.i386pe"
read ld_choice

if [ "$ld_choice" -eq 1 ]; then
    ld_arch_type="elf_x86_64"
elif [ "$ld_choice" -eq 2 ]; then
    ld_arch_type="elf32_x86_64"
elif [ "$ld_choice" -eq 3 ]; then
    ld_arch_type="elf_i386"
elif [ "$ld_choice" -eq 4 ]; then
    ld_arch_type="elf_iamcu"
elif [ "$ld_choice" -eq 5 ]; then
    ld_arch_type="i386linux"
elif [ "$ld_choice" -eq 6 ]; then
    ld_arch_type="elf_l1om"
elif [ "$ld_choice" -eq 7 ]; then
    ld_arch_type="elf_klom"
elif [ "$ld_choice" -eq 8 ]; then
    ld_arch_type="i386pep"
elif [ "$ld_choice" -eq 9 ]; then
    ld_arch_type="i386pe"
else
    $WORKING_DIRECTORY./AssembleMaker.sh
fi


ld -m $ld_arch_type -s $RELEASE_DIRECTORY_PATH*.o -o $RELEASE_NAME
