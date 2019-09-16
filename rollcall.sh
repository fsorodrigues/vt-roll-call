#!/bin/bash
function rollcall() {

    MYDIR=$"${BASH_SOURCE%/*}"
    year=$(<"$MYDIR/config.txt")
    chamber="h"
    set_year=false
    is_update=false

    while test $# -gt 0; do
           case "$1" in
                -id)
                    shift
                    roll_call_id=$1
                    shift
                    ;;
                -bill)
                    shift
                    bill=$1
                    shift
                    ;;
                -chamber)
                    shift
                    get_chamber=$1
                    shift
                    ;;
                -year)
                    shift
                    year=$1
                    shift
                    ;;
                -set-year)
                    shift
                    set_year=true
                    year=$1
                    shift
                    ;;
                -update)
                    shift
                    is_update=true
                    shift
                    ;;
                *)
                    echo "$1 is not a recognized flag!"
                    return 1;
                    ;;
          esac
    done

    if [ $is_update == false ];
        then

            if [ $set_year == false ];
                then
                    if [ $get_chamber == "h" ]
                        then
                            chamber="house"
                    fi

                    if [ $get_chamber == "s" ]
                        then
                            chamber="senate"
                    fi

                    if [ $(($year%2)) == 1 ]
                        then
                            year=$(($year+1))
                    fi

                    BASEURL=$"https://legislature.vermont.gov/bill/loadBillRollCallDetails"

                    curl "$BASEURL/$year/$roll_call_id" | ~/envs/csvkit/bin/in2csv -f json -k data > "$bill-raw.csv"

                    ~/envs/csvkit/bin/csvjoin "$bill-raw.csv" "$MYDIR/$chamber-lookup.csv" --snifflimit 0 -c "PersonID" > "$bill-complete.csv"

                else
                    echo $year > "$MYDIR/config.txt"
            fi

        else

            BASEURL=$"https://legislature.vermont.gov/people/loadAll"

            curl "$BASEURL/$year/House" | ~/envs/csvkit/bin/in2csv -f json -k data | ~/envs/csvkit/bin/csvcut -c PersonID,Town,PartyID,Party,District,FirstName,LastName > "$MYDIR/house-scraped.csv"
            ~/envs/csvkit/bin/csvsql --no-inference --query "SELECT PersonID,FirstName||' '||LastName FROM 'house-scraped'" "$MYDIR/house-scraped.csv" | sed "s/\"\"/\'/g" | sed "s/FirstName||\' \'||LastName/Name/g" > "$MYDIR/house-join.csv"
            ~/envs/csvkit/bin/csvjoin "$MYDIR/house-scraped.csv" "$MYDIR/house-join.csv" --snifflimit 0 -c "PersonID" | ~/envs/csvkit/bin/csvcut -c PersonID,Town,PartyID,Party,District,Name > "$MYDIR/house-lookup.csv"

            curl "$BASEURL/$year/Senate" | ~/envs/csvkit/bin/in2csv -f json -k data | ~/envs/csvkit/bin/csvcut -c PersonID,Town,PartyID,Party,District,FirstName,LastName > "$MYDIR/senate-scraped.csv"
            ~/envs/csvkit/bin/csvsql --no-inference --query "SELECT PersonID,FirstName||' '||LastName FROM 'senate-scraped'" "$MYDIR/senate-scraped.csv" | sed "s/\"\"/\'/g" | sed "s/FirstName||\' \'||LastName/Name/g" > "$MYDIR/senate-join.csv"
            ~/envs/csvkit/bin/csvjoin "$MYDIR/senate-scraped.csv" "$MYDIR/senate-join.csv" --snifflimit 0 -c "PersonID" | ~/envs/csvkit/bin/csvcut -c PersonID,Town,PartyID,Party,District,Name > "$MYDIR/senate-lookup.csv"

            rm *-scraped.csv
            rm *-join.csv

    fi

}

# ~/envs/csvkit/bin/csvsql --no-inference --query 'SELECT FirstName,LastName FROM stdin' > "$MYDIR/test.csv"
