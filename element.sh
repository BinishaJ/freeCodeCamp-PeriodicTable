PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

SYMBOL=$1

NO_ELEMENT() {
  echo -e "I could not find that element in the database."
}

DISPLAY() {
  INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  echo $INFO | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
}

# no argument
if [[ -z $SYMBOL ]]
then
  echo "Please provide an element as an argument."
else
  # if argument is not atomic_number
  if [[ ! $SYMBOL =~ ^[0-9]+$ ]]
  then
    LENGTH=$(echo -n "$SYMBOL" | wc -m)

    # for full element name
    if [[ $LENGTH -gt 2 ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$SYMBOL'")

      #if element doesn't exist
      if [[ -z $ATOMIC_NUMBER ]]
      then
        NO_ELEMENT
      else
        DISPLAY $ATOMIC_NUMBER
      fi
    # for element symbol
    else  
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")

       #if element doesn't exist
      if [[ -z $ATOMIC_NUMBER ]]
      then
        NO_ELEMENT
      else
        DISPLAY $ATOMIC_NUMBER
      fi
    fi
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$SYMBOL")

    #if element doesn't exist
    if [[ -z $ATOMIC_NUMBER ]]
    then
      NO_ELEMENT
    else
      DISPLAY $ATOMIC_NUMBER
    fi
  fi
fi
