#! /bin/bash
if [[ "$#" -ne 1 || "$1" != *.csv || ! -f "$1" ]]
then
    echo "usage: $0 .csv file"
    exit 1
fi

echo "************OSS1 - Project1************"
echo "*         StudentID : 12224434        *"
echo "*         Name : Hyeonjun Jo          *"
echo "***************************************"

file="$1"
file=$(cat "$file" | awk -F, 'NR != 1 {print $0}')
processed_file=$(echo "$file" | awk -F, '$8 >= 502 {print $0}')
stop="N"

search_player_by_name() {
    local player row

    read -p "Enter a player name to search : " player
    row=$(echo "$file" | awk -F, -v p="$player" '$2 == p {print $0}')

    while [ -z "$row" ]
    do
        echo -e "\nnon-existent player is entered"
        read -p "Enter a player name to search : " player
        row=$(echo "$file" | awk -F, -v p="$player" '$2 == p {print $0}')
    done

    echo "$row" | awk -F, '{print "\nPlayer stats for \"" $2 "\":"}'
    echo "$row" | awk -F, '{print "Player: " $2 \
                            ", Team: " $4 \
                            ", Age: " $3 \
                            ", WAR: " $6 \
                            ", HR: " $14 \
                            ", BA: " $20}'
}

list_top_5_players_by_slg_value() {
    local flag rows

    read -p "Do you want to see the top 5 players by SLG? (y/n) : " flag

    until [[ "$flag" = "y" || "$flag" = "n" ]]
    do
        echo -e "\nEnter the valid flag"
        read -p "Do you want to see the top 5 players by SLG? (y/n) : " flag
    done

    if [ "$flag" = "y" ]
    then
        echo -e "\n***Top 5 Players by SLG***"
        rows=$(echo "$processed_file" | sort -t, -k 22 -nr | head -n 5)

        if [ ! -z "$rows" ]
        then
            echo "$rows" | awk -F, '{print NR". " $2 \
                                     "(Team: " $4 ") - " \
                                     "SLG: " $22 ", " \
                                     "HR: " $14 ", " \
                                     "RBI: " $15}'
        fi
    else
        echo -e "\nBack to the Menu"
    fi
}

analyze_the_team_stats() {
    local team rows

    read -p "Enter team abbreviation (e.g., NYY, LAD, BOS) : " team
    rows=$(echo "$file" | awk -F, -v t="$team" '$4 == t {print $0}')
    
    while [ -z "$rows" ]
    do
        echo -e "\nnon-existent team is entered"
        read -p "Enter a team name to search : " team
        rows=$(echo "$file" | awk -F, -v t="$team" '$4 == t {print $0}')
    done

    if [ ! -z "$rows" ]
    then
        echo "$rows" | awk -F, -v t="$team" '{total_age += $3; \
                                              total_hr += $14; \
                                              total_rbi += $15; \
                                              cnt++;} \
                                              END \
                                              {printf "\nTeam stats for %s:\n", t;
                                              printf "Average age: %.1f\n", total_age / cnt;
                                              printf "Total home runs: %d\n", total_hr;
                                              printf "Total RBI: %d\n", total_rbi;}'
    fi
}

compare_players_in_different_age_groups() {
    local group cur_group rows

    echo -e "\nCompare players by age groups:"
    echo -e "1. Group A (Age < 25)"
    echo -e "2. Group B (Age 25-30)"
    echo -e "3. Group C (Age > 30)"
    read -p "Select age group (1-3): " group
    
    until [[ "$group" -ge 1 && "$group" -le 3 ]]
    do
        echo -e "\nEnter the valid group"
        read -p "Select age group (1-3): " group
    done

    case "$group" in
    1)
        cur_group="Group A (Age < 25)"
        rows=$(echo "$processed_file" | awk -F, '$3 < 25 {print $0}')
        ;;
    2)
        cur_group="Group B (Age 25-30)"
        rows=$(echo "$processed_file" | awk -F, '$3 >= 25 && $3 <= 30 {print $0}')
        ;;
    3)
        cur_group="Group C (Age > 30)"
        rows=$(echo "$processed_file" | awk -F, '$3 > 30 {print $0}')
        ;;
    esac

    rows=$(echo "$rows" | sort -t, -k 22 -nr | head -n 5)
    echo -e "\nTop 5 by SLG in $cur_group:"
    if [ ! -z "$rows" ]
    then
        echo "$rows" | awk -F, '{print $2 " (" $4 ") - " \
                                    "Age: " $3 ", " \
                                    "SLG: " $22 ", " \
                                    "BA: " $20 ", " \
                                    "HR: " $14}'
    fi
}

search_the_players_who_meet_specific_statistical_conditions() {
    local min_hr min_ba rows

    echo -e "\nFind players with specific criteria"
    read -p "Minimum home runs: " min_hr

    until [ "$min_hr" -ge 0 ]
    do
        echo -e "\nEnter the valid number"
        read -p "Minimum home runs: " min_hr
    done

    read -p "Minimum batting average (e.g., 0.280): " min_ba

    while echo "$min_ba" | awk '{exit ($1 >= 0.0 && $1 <= 1.0)}'
    do
        echo -e "\nEnter the valid number"
        read -p "Minimum batting average (e.g., 0.280): " min_ba
    done

    echo -e "\nPlayers with HR ≥ "$min_hr" and BA ≥ "$min_ba":"
    rows=$(echo "$processed_file" | awk -F, -v mh="$min_hr" -v mb="$min_ba" '$14 >= mh && $20 >= mb {print $0}')
    rows=$(echo "$rows" | sort -t, -k 14 -nr)

    if [ ! -z "$rows" ]
    then
        echo "$rows" | awk -F, '{print $2 " (" $4 ") - " \
                                "HR: " $14 ", " \
                                "BA: " $20 ", " \
                                "RBI: " $15 ", " \
                                "SLG: " $22}'
    fi
}

generate_a_perfomance_report() {
    local team rows

    echo "Generate a formatted player report for which team?"
    read -p "Enter team abbreviation (e.g., NYY, LAD, BOS): " team
    rows=$(echo "$file" | awk -F, -v t="$team" '$4 == t {print $0}')

    while [ -z "$rows" ]
    do
        echo -e "\nnon-existent team is entered"
        read -p "Enter a team name to search : " team
        rows=$(echo "$file" | awk -F, -v t="$team" '$4 == t {print $0}')
    done

    echo -e "\n===================== "$team" PLAYER REPORT ====================="
    date=$(date +"%Y/%m/%d")
    echo "Date: "$date""
    echo "-------------------------------------------------------------"
    echo "PLAYER                          HR   RBI   AVG    OBP    OPS"
    echo "-------------------------------------------------------------"
    echo "$rows" | sort -t, -k 14 -nr | awk -F, '{printf "%-30s %3d %5d %6.3f %6.3f %6.3f\n", $2, $14, $15, $20, $21, $23}'
    echo "-------------------------------------------------------------"
    cnt=$(echo "$rows" | wc -l)
    echo "TEAM TOTALS: $cnt players"
}

until [ "$stop" = "Y" ]
do
    echo -e "\n[Menu]"
    echo "1. Search player stats by name in MLB data"
    echo "2. List top 5 players by SLG value"
    echo "3. Analyze the team stats - average age and total home runs"
    echo "4. Compare players in different age groups"
    echo "5. Search the players who meet specific statistical conditions"
    echo "6. Generate a performance report (formatted data)"
    echo "7. Quit"
    read -p "Enter your COMMAND (1~7) : " choice

    case "$choice" in
    1)
        search_player_by_name
        ;;
    2)
        list_top_5_players_by_slg_value
        ;;
    3)
        analyze_the_team_stats
        ;;
    4)
        compare_players_in_different_age_groups
        ;;
    5)
        search_the_players_who_meet_specific_statistical_conditions
        ;;
    6)
        generate_a_perfomance_report
        ;;
    7)
        echo "Have a good day!"
        stop="Y"
        ;;
    *)
        echo -e "\nEnter the valid choice"
    esac
done