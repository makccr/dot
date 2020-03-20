#!/usr/bin/env bash

INFO=$(ioreg -l -n AppleSmartBattery -r)

# Charge and time remaining
CURRENT_CAPACITY=$(echo "$INFO" | grep CurrentCapacity | awk '{printf $3; exit}')
MAX_CAPACITY=$(echo "$INFO" | grep MaxCapacity | awk '{printf $3; exit}')
CHARGE=$((CURRENT_CAPACITY * 100 / MAX_CAPACITY))
CELLS=$(python -c "f='●'*($CHARGE/10) + '○'*(10-$CHARGE/10); print f")
STATUS_INFO=Draining...

CHARGING=$(echo "$INFO" | grep -i ischarging | awk '{printf("%s", $3)}')
TIME_TO_EMPTY=$(echo "$INFO" | grep -i AvgTimeToEmpty | awk '{printf("%s", $3)}')
TIME_LEFT=Calculating…

if [ "$TIME_TO_EMPTY" -lt 15000 ]; then
    TIME_LEFT=$(echo "$INFO" | grep -i AvgTimeToEmpty | awk '{printf("%i:%.2i", $3/60, $3%60)}')
fi

if [ "$CHARGING" == Yes ]; then
    TIME_FULL=$(echo "$INFO" | grep -i AvgTimeToFull | tr '\n' ' | ' | awk '{printf("%i:%.2i", $3/60, $3%60)}')
    TIME_INFO=$(echo "$TIME_FULL" until full)
    STATUS_INFO=Charging...
    BATT_ICON=charging.png
else
    FULLY_CHARGED=$(echo "$INFO" | grep -i FullyCharged | awk '{printf("%s", $3)}')
    EXTERNAL=$(echo "$INFO" | grep -i ExternalConnected | awk '{printf("%s", $3)}')
    if [ "$FULLY_CHARGED" == Yes ]; then
        if [ "$EXTERNAL" == Yes ]; then
            TIME_INFO="On AC power"
            STATUS_INFO="Fully Charged"
            BATT_ICON=power.png
        else
            TIME_INFO=$TIME_LEFT
            BATT_ICON=full.png
        fi
    else
        TIME_INFO=$TIME_LEFT
        BATT_ICON=critical.png
        if [ "$CHARGE" -gt 80 ]; then
            BATT_ICON=full.png
        elif [ "$CHARGE" -gt 50 ]; then
            BATT_ICON=medium.png
        elif [ "$CHARGE" -gt 10 ]; then
            BATT_ICON=low.png
        fi
    fi
fi

# Temperature
TEMPERATURE=$(echo "$INFO" | grep Temperature | awk '{printf ("%.1f", $3/10-273)}')

# Cycle count
CYCLE_COUNT=$(echo "$INFO" | grep -e '"CycleCount" =' | awk '{printf ("%i", $3)}')

# Battery health
DESIGN_CAPACITY=$(echo "$INFO" | grep DesignCapacity | awk '{printf $3; exit}')
HEALTH=$((MAX_CAPACITY * 100 / DESIGN_CAPACITY))

if [ "$HEALTH" -gt 100 ]; then
    HEALTH=100
fi

# Serial
SERIAL=$(echo "$INFO" | grep BatterySerialNumber | awk '{printf ("%s", $3)}' | tr -d '"')

# Battery age
MANUFACTURE_DATE=$(echo "$INFO" | grep ManufactureDate | awk '{printf ("%i", $3)}')
day=$((MANUFACTURE_DATE&31))
month=$(((MANUFACTURE_DATE>>5)&15))
year=$((1980+(MANUFACTURE_DATE>>9)))
AGE=$(python -c "from datetime import date as D; d1=D.today(); d2=D($year, $month, $day); print ( (d1.year - d2.year)*12 + d1.month - d2.month )")

# Alfred feedback
cat << EOB
<?xml version="1.0"?>
<items>
  <item>
    <title>$CHARGE% $CELLS</title>
	<subtitle>$STATUS_INFO</subtitle>
	<icon>icons/$BATT_ICON</icon>
  </item>
  <item>
    <title>$TIME_INFO</title>
	<subtitle>Time Left</subtitle>
	<icon>icons/clock.png</icon>
  </item>
  <item>
    <title>$TEMPERATURE °C</title>
	<subtitle>Temperature</subtitle>
	<icon>icons/temp.png</icon>
  </item>
  <item>
    <title>$CYCLE_COUNT</title>
	<subtitle>Charge Cycles Completed</subtitle>
	<icon>icons/cycles.png</icon>
  </item>
  <item>
    <title>$HEALTH%</title>
	<subtitle>Health</subtitle>
	<icon>icons/health.png</icon>
  </item>
  <item>
    <title>$SERIAL</title>
	<subtitle>Serial</subtitle>
	<icon>icons/serial.png</icon>
  </item>
  <item>
    <title>$AGE months</title>
	<subtitle>Age</subtitle>
	<icon>icons/age.png</icon>
  </item>
</items>
EOB
