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
    echo "** Please note: This query may take a few minutes. **"
    az consumption usage list --start-date "${from}" --end-date "${to}" --query "[?tags.[AppID=='${appid}',CostCenter=='${cc}',PSO=='${pso}']].{Service:consumedService,Usage:usageQuantity,BillableDollars:pretaxCost}" -o table
  else
    echo " - Ok. Outputting total billing amount for all-time..."
    echo "** Please note: This query may take a few minutes. **"
    az consumption usage list --query "[?tags.[AppID=='${appid}',CostCenter=='${cc}',PSO=='${pso}']].{Service:consumedService,Usage:usageQuantity,BillableDollars:pretaxCost}" -o table
fi
