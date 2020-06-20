#!/bin/bash

function usage()
{
  echo "Usage: 'linkid ID' to search for link."
  echo "To add to the dictionary use the -a flag: 'linkid -a LINK'"
}
function chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

function ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

args=("$@")
adding=0
link=
id=

while [ "$1" != "" ]; do
  case $1 in
    -a | --add )  shift
                  link=$1
                  adding=1
                  ;;
    -h | --help ) usage
                  exit
  esac
  shift
done

if [ "$adding" = "0" ]; then
  id=${args[0]}
  if [ "${args[0]}" = "" ]; then
    echo "Please enter an id. Use the --help flag for help."
    exit 1
  else
    value=$(grep "$id" data.txt | sed 's/.*,//')
    #value=$(grep "$id" data.txt | sed 's/^[^,]*//')
    if [ "$value" = "" ]; then
      echo "No match found! (IDs are lowercase)"
      exit 1
    else
      echo $value
      exit 0
    fi
  fi
fi
if [ "$link" = "" ]; then
  echo "Please provide a link. Use the --help flag for help."
  exit 1
else
  # Convert ID(eg ghik) to 4 numbers in the format a,b,c,d
  last=$(tail -n 1 data.txt | sed 's/,.*//')
  a=$(ord ${last:0:1})
  b=$(ord ${last:1:2})
  c=$(ord ${last:2:3})
  d=$(ord ${last:3:4})
  

  # Increment the ID by 1, eg aaaa->aaab->...->aaaz->aaba
  if [ $d -lt 122 ]; then
    ((d+=1))
  else
    if [ $c -lt 122 ]; then
      ((c+=1))
      ((d=97))
    else
      if [ $b -lt 122 ]; then
        ((b+=1))
        ((c=97))
        ((d=97))
      else
        if [ $a -lt 122]; then
          ((a+=1))
          ((b=97))
          ((c=97))
          ((d=97))
        else
          echo "ID zzzz exceeded!"
          exit 1
        fi
      fi
    fi
  fi
  
  # Convert back to text
  a=$(chr $a)
  b=$(chr $b)
  c=$(chr $c)
  d=$(chr $d)
  id="$a$b$c$d"

  echo "$id,$link" >> data.txt
  exit 0
fi
