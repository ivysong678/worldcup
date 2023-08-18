#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR -ne "year" ]]
  then
    TEAM_WIN_RESULT=$($PSQL "select name from teams where name='$WINNER'")
    TEAM_OPP_RESULT=$($PSQL "select name from teams where name='$OPPONENT'")
    if [[ -z $TEAM_WIN_RESULT ]]
    then
      INSERT_WIN=$($PSQL "insert into teams(name) values('$WINNER')")
    fi
    if [[ -z $TEAM_OPP_RESULT ]]
    then
      INSERT_OPP=$($PSQL "insert into teams(name) values('$OPPONENT')")
    fi
    TEAM_WIN_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    TEAM_OPP_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    INSERT_GAMES=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
    values($YEAR,'$ROUND',$TEAM_WIN_ID,$TEAM_OPP_ID,$W_GOALS,$O_GOALS)")
  fi
done
