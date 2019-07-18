#!/bin/bash
function rollcall() {

    MYDIR=$"${BASH_SOURCE%/*}"
    year=$(<"$MYDIR/config.txt")
    chamber="h"
    set_year=false

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
                *)
                   echo "$1 is not a recognized flag!"
                   return 1;
                   ;;
          esac
    done

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

            ~/envs/csvkit/bin/csvjoin "$bill-raw.csv" "$MYDIR/$chamber-lookup.csv" --snifflimit 0 -c "PersonID" > "$bill-joined.csv"

        else
            echo $year > "$MYDIR/config.txt"
    fi

}
