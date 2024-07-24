#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"



echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

  
  echo -e "\nWelcome to my salon, what service would you like to get?\n"

  SERVICE_LIST=$($PSQL "SELECT * FROM services;")

  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done  

  
  #check if the entered value is not a number
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then

    # send to main menu
    MAIN_MENU "You need to write a service number presented on the list."
  
  else
    # get service availability


    SERVICE_AVAILABILITY=$($PSQL "SELECT * FROM services WHERE service_id = $SERVICE_ID_SELECTED;" )

    if [[ -z $SERVICE_AVAILABILITY ]]
    then 

      MAIN_MENU "I could not find that service. Try again"
    
    else
      # ask for phone number
      echo -e "\nWhat is your phone number?\n"
      read CUSTOMER_PHONE
      
      # check if name is new or not
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

      if [[ -z $CUSTOMER_NAME ]]
      then 
        # if this is a new customer
        echo -e "\nWhat is your name?\n"
        read CUSTOMER_NAME

        INSERT_NEW_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")

      fi

      #ask for appointment time
      echo -e "\nWhat is your desired service time?\n"
      read SERVICE_TIME

      INSERT_NEW_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (time) VALUES ('$SERVICE_TIME');" )

      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;" )

      echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    fi

    

  fi

  

}



MAIN_MENU

