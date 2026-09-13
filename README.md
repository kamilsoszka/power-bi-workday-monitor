# Power BI Workday Monitor

A code-first Power BI workday monitoring solution built with DAX, Power Query M, and Power BI Service.

## Overview

The Workday Monitor displays:

- Current local date and time for Poland
- Automatic CET and CEST time-zone detection
- Work start and end times
- Total workday duration
- Elapsed work time
- Remaining work time
- Workday progress percentage
- Remaining work percentage
- Workday status
- Weekend detection
- Text-based progress bar
- Semantic model last refresh timestamp

## Default work schedule

The current implementation uses the following schedule:

- Work start: `08:00:00`
- Work end: `16:00:00`
- Workday duration: `08:00:00`
- Working days: Monday to Friday
- Non-working days: Saturday and Sunday
- Time zone: Europe/Warsaw

## Repository structure

```text
power-bi-workday-monitor/
├── dax/
│   └── Workday Monitor.dax
├── power-query/
│   └── RefreshInfo.pq
└── README.md
