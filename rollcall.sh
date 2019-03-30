#!/bin/bash
function rollcall() {

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
                    get_chamber=$(echo $1| cut -d'.' -f 1)
                    shift
                    ;;
                *)
                   echo "$1 is not a recognized flag!"
                   return 1;
                   ;;
          esac
    done

    if [ $get_chamber == "h" ]
        then
            shift
            chamber="house"
            shift
    fi

    if [ $get_chamber == "s" ]
        then
            shift
            chamber="senate"
            shift
    fi

    MYDIR=$"${BASH_SOURCE%/*}"

    curl "https://legislature.vermont.gov/bill/loadBillRollCallDetails/2020/$roll_call_id" | in2csv -f json -k data > "$bill-raw.csv"

    csvjoin "$bill.csv" "/Users/fsorodrigues/get-roll-call/$chamber-lookup.csv" --snifflimit 0 -c "PersonID" > "$bill-joined.csv"

}
