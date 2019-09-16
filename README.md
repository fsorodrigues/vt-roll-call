# VT Roll Call

A CLI tool to download Vermont's legislature Roll Call votes.

## Dependencies

- `csvkit`  
See documentation [here](https://csvkit.readthedocs.io/en/latest/)
- `sed`  
Normally ships in UNIX systems. More about it [here](https://www.gnu.org/software/sed/).

## Installation

Make shell script executable:
```bash
cd path/to/roll/call/folder
chmod +x ./rollcall.sh
```

Then we need to modify the `.bash-profile` file (or equivalent).
First open it in a text editor:
```bash
nano ~/.bash_profile
```
Then add
```nano
source path/to/roll/call/folder/rollcall.sh
```
to your `.bash-profile`.

To finish up, reload your `.bash-profile` with:
```bash
source ~/.bash_profile
```

## Syntax

### Output

```bash
rollcall -id <roll-call-id> -bill <bill-number> -chamber <chamber-initial>
```

`<roll-call-id>` can be detected from the roll call URLs in the legislature's website:

In `https://legislature.vermont.gov/bill/roll-call/2020/36`, the `<roll-call-id>` is 36.

`<bill-number>` is self-explanatory, but needs to follow the legislature's convention:
h.444 or s.55, *always uncapitalized*.

`<chamber-initial>` h for house, s for senate, *always uncapitalized*. Represents the chamber voting on bill.

Two `csv` files will be created in the current working directory:

- `<bill-number>-raw.csv`
- `<bill-number>-complete.csv`

If files with those names already exist in the directory, they will be overwritten.

### Config

Two flags have been created for configuration:

- `-set-year <year>`: allows users to set the legislature to be scraped. Input calendar years and script will automatically calculate the legislature.
```bash
rollcall -set-year 2019
```
The command will update `config.txt`.

- `-update`: regenerates lookup files that are used for complete output. Should be used when changing years or when new legislators are introduced mid-legislature.
```bash
rollcall -update
```
