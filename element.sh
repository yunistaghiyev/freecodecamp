#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

WRITTEN_OPTION=$1


if [[ -z $WRITTEN_OPTION ]]
then
  echo "Please provide an element as an argument."

else
  #check if input is a number

  if [[ ! $WRITTEN_OPTION =~ ^[0-9]+$ ]]
  then

    LENGTH_OF_INPUT=${#WRITTEN_OPTION}
    
    #check if the input contains more than 2 symbols
    if [[ $LENGTH_OF_INPUT > 2 ]]
    then
      #element name is provided
      SELECT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$WRITTEN_OPTION'; ")
    
    else
      #element symbol is provided
      SELECT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$WRITTEN_OPTION'; ")
    fi

  else
    #element's atomic number is provided
    SELECT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $WRITTEN_OPTION; ")
  fi

  if [[ -z $SELECT_ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else

    #select the row with necessary atomic properties
    SELECT_ASSOCIATED_PROPERTIES=$($PSQL "SELECT * FROM elements RIGHT JOIN properties USING (atomic_number) RIGHT JOIN types USING (type_id) WHERE atomic_number = $SELECT_ATOMIC_NUMBER;")

    
    echo "$SELECT_ASSOCIATED_PROPERTIES" | sed 's/|/ | /g' | while read ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi

fi


