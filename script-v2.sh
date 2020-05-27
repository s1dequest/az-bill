#!/bin/bash
#  WORK IN PROGRESS. DO NOT USE.
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

continue="y"
# Put below in a loop so we can ask if the user would like to get billing information for more clusters.
if [ "$continue" == "y" ];
  then
    echo "Please input the tagged AppID, CostCenter, and PSO (exactly as it is shown in Azure)."
    read -p "AppID: " appid
    read -p "CostCenter: " cc
    read -p "PSO: " pso
    read -p "Would you like to restrict your billing metrics to a date range? [y/n]: " datebool
    # echo "What date range would you like to see?"
    # read -p "From [yyyy-mm-dd]:" from
    # read -p "To [yyyy-mm-dd]:" to

    # az consumption usage list --query "[?tags.[AppID=='${appid}',CostCenter=='${cc}',PSO=='${pso}']].{Service:consumedService,Usage:usageQuantity,BillableDollars:pretaxCost}" -o table

    read -p "Would you like to get the billing information for another cluster? [y/n]: " $continue
  else
    echo "Thank you. Goodbye."
fi
