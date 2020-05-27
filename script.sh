#!/bin/bash
set -e
echo "************************************************************"
echo "*                       HELLO                              *"
echo "*                                                          *"
echo "*    This script is designed to output valuable billing    *"
echo "*    data for the given user input Azure resource tags.    *"
echo "*    You will have the option to output raw json to a      *"
echo "*    file in your current directory, or a table with       *"
echo "*    a few key metrics for billing in 4Wheels.             *"
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
echo "Please input the tagged AppID, CostCenter, and PSO (exactly as it is shown in Azure)."
read -p "(1/4) AppID: " appid
read -p "(2/4) CostCenter: " cc
read -p "(3/4) PSO: " pso
read -p "(4/4) Would you like to restrict your billing metrics to a date range? [y/n]: " datebool
if [ "$datebool" == "y" ];
  then
    echo " - What date range would you like to see?"
    read -p "   - From [yyyy-mm-dd]: " from
    read -p "   - To [yyyy-mm-dd]: " to
    az consumption usage list --start-date "${from}" --end-date "${to}" --query "[?tags.[AppID=='${appid}',CostCenter=='${cc}',PSO=='${pso}']].{Service:consumedService,Usage:usageQuantity,BillableDollars:pretaxCost}" -o table
    # az consumption usage list --query "[?tags.[AppID=='${appid}',CostCenter=='${cc}',PSO=='${pso}']].{Service:consumedService,Usage:usageQuantity,BillableDollars:pretaxCost}" -o table
fi
