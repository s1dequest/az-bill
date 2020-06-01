#!/bin/bash
set -e
echo "************************************************************"
echo "*                       HELLO                              *"
echo "*                                                          *"
echo "*    This script is designed to output valuable billing    *"
echo "*    data for the given Azure resource tags. Note that     *"
echo "*    values are output in USD ($) and summed over all      *"
echo "*    resources for the matching cluster(s).                *"
echo "*                                                          *"
echo "*                       ^  ^                               *"
echo "*                      _|__|_                              *"
echo "*                    <| O  O |>                            *"
echo "*                     |_[~~]_|                             *"
echo "*                     ___||___                             *"
echo "*                 Bill-O-Tron-9000                         *"
echo "*                                                          *"
echo "************************************************************"
echo ""

# User inputs to restrict search results to only matching tagged resources.
echo "Please input the tagged AppID, CostCenter, and PSO (exactly as it is shown in Azure)."
read -p "(1/4) AppID: " appid
read -p "(2/4) CostCenter: " cc
read -p "(3/4) PSO: " pso
read -p "(4/4) Would you like to restrict your billing metrics to a date range? [y/n]: " datebool

# Loop based on date restriction. AZ CLI Command to grab json data for matching resources.
if [ "$datebool" == "y" ];
  then
    echo " - What date range would you like to see?"
    read -p "   - From [yyyy-mm-dd]: " from
    read -p "   - To [yyyy-mm-dd]: " to
    echo "** Please note: This query may take a few minutes. **"
    az consumption usage list --start-date "${from}" --end-date "${to}" --query "[?tags.AppID=='${appid}'] | [?tags.CostCenter=='${cc}'] | [?tags.PSO=='${pso}'].{Tags:tags,Usage:usageQuantity,BillableDollars:pretaxCost}" -o json > raw-data.json
    total=$(cat raw-data.json | jq -r '.[].BillableDollars' | awk '{ sum += $1; } END { print sum; }' "$@")
    echo "Between $from and $to, the total, pretax, billable US Dollars for $appid is: \$$total"
    echo "Thank you for using Bill-O-Tron-9000."
  else
    echo " - Ok. Outputting total billing amount for all-time..."
    echo "** Please note: This query may take a few minutes. **"
    az consumption usage list --query "[?tags.AppID=='${appid}'] | [?tags.CostCenter=='${cc}'] | [?tags.PSO=='${pso}'].{Tags:tags,Usage:usageQuantity,BillableDollars:pretaxCost}" -o json > raw-data.json
    total=$(cat raw-data.json | jq -r '.[].BillableDollars' | awk '{ sum += $1; } END { print sum; }' "$@")
    echo "The total, pretax, billable US Dollars for $appid is: \$$total"
    echo "Thank you for using Bill-O-Tron-9000."
fi

rm -rf raw-data.json
rm -rf bills.txt
