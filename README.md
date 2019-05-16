# VT Roll Call

A CLI tool to download Vermont's legislature Roll Call votes.

## Dependencies

`csvkit`

see documentation [here](https://csvkit.readthedocs.io/en/latest/)

## Installation

Make shell script executable:
```
cd path/to/roll/call/folder
chmod +x ./rollcall.sh
```

Then we need to modify the `.bash-profile` file (or equivalent).
First open it in a text editor:
```
nano ~/.bash_profile
```
Then add
```
source path/to/roll/call/folder/rollcall.sh
```
to your `.bash-profile`.

To finish up, reload your `.bash-profile` with:
```
source ~/.bash_profile
```

## Syntax

`rollcall -id <roll-call-id> -bill <bill-number> -chamber <chamber-initial>`

`<roll-call-id>` can be detected from the roll call URLs in the legislature's website:

In `https://legislature.vermont.gov/bill/roll-call/2020/36`, the `<roll-call-id>` is 36.

`<bill-number>` is self-explanatory, but needs to follow the legislature's convention:
h.444 or s.55, *always uncapitalized*.

`<chamber-initial>` h for house, s for senate, *always uncapitalized*. Represents the chamber voting on bill.

## Result

Two `csv` files will be created in the current working directory:

```
<bill-number>-raw.csv
<bill-number>-joined.csv
```

If files with those names already exist in the directory, they will be overwritten.
