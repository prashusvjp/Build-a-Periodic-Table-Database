if [[ -z $1 ]]
then
  #if no arguements passed
  echo "Please provide an element as an argument."
else
  #if argument passed
  PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
  #check if it is a digit
  if [[ $1 =~ ([0-9]+) ]]
  then
    #if argument is a digit
    GET_DATA="$($PSQL "select  elements.atomic_number, symbol, name, type, atomic_mass, 
    melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) 
    inner join types using(type_id) where elements.atomic_number=$1;")"
  else
    #if not a digit 
    GET_DATA="$($PSQL "select  elements.atomic_number, symbol, name, type, atomic_mass, 
    melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) 
    inner join types using(type_id) where symbol='$1' or name='$1';")"
  fi

  if [[ -z $GET_DATA ]]
  then
    echo "I could not find that element in the database."
  else
    echo  $GET_DATA| sed 's/|/ /g' | 
    while read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
