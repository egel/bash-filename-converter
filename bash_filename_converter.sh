#!/bin/bash

bash_ver=${BASH_VERSION}
EXT=png
green='\e[0;32m' # '\e[1;32m' is too bright for white bg.
endColor='\e[0m'
DIR=~/Pulpit/E14/
AMOUNT_OF_FILES=$(ls -1 $DIR | wc -l)

echo '############################################'
echo "# Program do zbiorowej zamiany nazw plików #"
echo '############################################'
echo ''
echo "Przykład 1: 'Obraz.png' zamieni na '1.png'"
echo "Przykład 2: 'Obraz (10).png' zamieni na '010.png'"
echo ''

echo "Bash version: ${bash_ver}"
cd $DIR
echo "Zmiana ścieżki na: "$(pwd)
echo "Katalog zawiera pliki w liczbie:" $AMOUNT_OF_FILES

echo ''
echo "Usuwanie niepotrzebnych elementow z nazwy kazdego pliku"
echo '-------------------------------------------------------'

PHRASE="Puste spacje: "
rename "s/ *//g" *.$EXT      # Usunie wszystkie spacje spośród nazw plików
PHRASE+=" ${green}Ukończono${endColor}"
echo -e $PHRASE

PHRASE="Fraza 'Obraz': "
rename 's/Obraz./1./' *.$EXT   # Zamieni tekst 'Obraz.' na '1.' spośród nazw plików
PHRASE+=" ${green}Ukończono${endColor}"
echo -e $PHRASE

PHRASE="Fraza 'Obraz(': "
rename 's/Obraz\(//' *.$EXT  # Usunie tekst 'Obraz(' spośród nazw plików
PHRASE+=" ${green}Ukończono${endColor}"
echo -e $PHRASE

PHRASE="Fraza ')': "
rename 's/\)//' *.$EXT       # Usunie tekst ')'
PHRASE+=" ${green}Ukończono${endColor}"
echo -e $PHRASE

echo ''
echo "Zamiana nazw plików (np: 1.png -> 0001.png)"
echo '-------------------------------------------'


TEMP_ARRAY=() # definicja tablicy
for currentFile in *.$EXT
do
  extension="${currentFile##*.}"
  filename="${currentFile%.*}"
  TEMP_ARRAY=( "${TEMP_ARRAY[@]}" "${filename}" ) # add item to array

  # Update max lenght of string if applicable
  if [[ "${#filename}" -gt "$max" ]]; then
      max="${#filename}"
  fi
done

echo -e "Liczba elementów w tablicy:" ${#TEMP_ARRAY[@]}
echo -e "Maxymalna długość nazwy pliku (bez rozszerzenia):" ${max}
echo ''
echo -e "Konwertowanie: "
for (( i=0; i<${#TEMP_ARRAY[@]} ; i++ ))  # the 'i' would be the 'filename'
do
  number_of_zeros=$(($max-${#TEMP_ARRAY[i]}))
  #echo "${TEMP_ARRAY[i]}, $number_of_zeros"   # for check if the number of zeros is correct
  fullname=""
  if [[ "$number_of_zeros" -ne "0" ]]; then
    for (( k = 0; k < $number_of_zeros; k++ )); do
      fullname+="0"
    done
    fullname+="${TEMP_ARRAY[i]}"
    fullname+=".$EXT"
    # echo -ne $fullname
    # echo " -> Należy użyć konwersji"
    echo "${TEMP_ARRAY[i]}.$EXT" "$fullname"
    mv "${TEMP_ARRAY[i]}.$EXT" "$fullname"
  else
    fullname+="${TEMP_ARRAY[i]}"
    fullname+=".$EXT"
    echo -ne $fullname
    echo " -> BRAK konwersji"
  fi
  # echo -ne "."
done
echo " Zakończono "
