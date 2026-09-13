# Power BI Workday Monitor

> One DAX measure. One semantic model. A complete workday monitoring solution.

A code-first workday monitoring solution developed directly in Power BI Service using DAX, Power Query M, TMDL, and a Power BI semantic model.

The project demonstrates how a single primary DAX measure can present local date and time, working-hours calculations, workday progress, weekend status, and the semantic model refresh timestamp.

## Report Preview

report-preview.png

## Overview

Power BI Workday Monitor displays:

- Current local date and time for Poland
- Automatic CET and CEST time-zone detection
- Configurable work start and end times
- Total workday duration
- Elapsed working time
- Remaining working time
- Workday progress percentage
- Remaining work percentage
- Current workday status
- Weekend detection
- Weekend schedule information
- Text-based progress bar
- Semantic model refresh timestamp converted to local time

The report is based on one primary DAX measure displayed directly in a Power BI table visual.

## Default Work Schedule

The default working schedule is:

```text
Work start: 08:00:00
Work end:   16:00:00
Duration:   08:00:00
```

The schedule can be changed in the DAX measure by editing:

```DAX
VAR WorkStartTime =
    TIME(8, 0, 0)

VAR WorkEndTime =
    TIME(16, 0, 0)
```

The current implementation supports schedules that start and end on the same calendar day.

## Architecture

```text
Power Query M
    |
    | Captures the UTC refresh timestamp
    v
RefreshInfo[LastRefreshUTC]
    |
    | Provides the refresh timestamp
    v
Power BI semantic model
    |
    | Executes the Workday Monitor DAX measure
    v
Power BI report
    |
    | Published for users
    v
Power BI app
```

## Technologies

- Power BI Service
- Power BI semantic models
- DAX
- Power Query M
- Tabular Model Definition Language
- Microsoft Fabric
- GitHub

## Repository Structure

```text
power-bi-workday-monitor/
|
|-- dax/
|   `-- WorkdayMonitor.dax
|
|-- power-query/
|   `-- RefreshInfo.pq
|
|-- tmdl/
|   `-- Measures.tmdl
|
|-- report-preview.png
|
`-- README.md
```

## Source Files

### DAX Measure

The complete `Workday Monitor` measure is available in:

dax/WorkdayMonitor.dax

The measure is responsible for:

- Warsaw local date and time
- CET and CEST detection
- Work schedule validation
- Workday duration calculation
- Elapsed and remaining working time
- Workday progress calculations
- Weekend behavior
- Workday status
- Text-based progress bar
- Local refresh-time presentation
- Final formatted report output

### Power Query M

The refresh timestamp query is available in:

power-query/RefreshInfo.pq

The query creates a one-row table containing the UTC timestamp captured during semantic model refresh:

```powerquery
let
    RefreshTimestamp =
        DateTimeZone.FixedUtcNow(),

    RefreshInfo =
        #table(
            type table [
                LastRefreshUTC = datetimezone
            ],
            {
                {
                    RefreshTimestamp
                }
            }
        )
in
    RefreshInfo
```

### TMDL Definition

The semantic model definition is available in:

tmdl/Measures.tmdl

The TMDL file documents:

- The `_Measures` table
- The `Workday Monitor` measure
- The hidden placeholder column
- The Power Query partition
- The semantic model metadata

## How It Works

### Current Local Time

The calculation starts with UTC as the common time reference:

```DAX
VAR CurrentUtcDateTime =
    UTCNOW()
```

The DAX measure then determines whether CET or CEST currently applies in Warsaw.

### Daylight-Saving Time

Daylight-saving time is calculated using:

- The last Sunday of March at 01:00 UTC
- The last Sunday of October at 01:00 UTC

The UTC offset is selected automatically:

```text
Winter: CET, UTC+1
Summer: CEST, UTC+2
```

### Workday Calculation

The measure compares the current Warsaw time with the configured work schedule.

It calculates:

```text
Workday duration
Elapsed work time
Remaining work time
Completed percentage
Remaining percentage
Current workday status
```

Progress values are restricted to the valid range from `0%` to `100%`.

### Weekend Behavior

Saturday and Sunday are treated as non-working days.

The report displays:

```text
Status: Weekend
No working hours scheduled
Progress: 0.0%
Remaining: 0.0%
```

### Refresh Timestamp

Power Query captures the UTC timestamp when the semantic model is refreshed.

The DAX measure converts this timestamp to Warsaw local time and displays it as:

```text
Last refreshed date:
13 Sep 2026 17:36:50 CEST
```

This value represents the semantic model refresh timestamp, not the current report calculation time.

## Expected Behavior

### Before Work

```text
Elapsed time: 00:00:00
Remaining time: 08:00:00
Progress: 0.0%
Remaining: 100.0%
Status: Before work

Progress bar:
-------------------- 0.0%
```

### During Work

Example at 12:00:

```text
Elapsed time: 04:00:00
Remaining time: 04:00:00
Progress: 50.0%
Remaining: 50.0%
Status: Work in progress

Progress bar:
==========---------- 50.0%
```

### After Work

```text
Elapsed time: 08:00:00
Remaining time: 00:00:00
Progress: 100.0%
Remaining: 0.0%
Status: Workday completed

Progress bar:
==================== 100.0%
```

### Weekend

```text
Elapsed time: 00:00:00
Remaining time: 00:00:00
Progress: 0.0%
Remaining: 0.0%
Status: Weekend
No working hours scheduled

Progress bar:
-------------------- 0.0%
```

### Missing Refresh Timestamp

```text
Last refreshed date:
Not available
```

### Invalid Work Schedule

If the work end time is equal to or earlier than the work start time:

```text
Workday duration: 00:00:00
Elapsed time: 00:00:00
Remaining time: 00:00:00
Progress: 0.0%
Remaining: 0.0%
Status: Invalid work schedule
```

## Deployment in Power BI Service

### 1. Create the Measure Table

Create or import a small helper table:

```csv
Placeholder
Measures
```

Rename the table to:

```text
_Measures
```

Hide the `Placeholder` column from the report view.

### 2. Create the Refresh Query

Open Power Query and create a blank query.

Paste the contents of:

```text
power-query/RefreshInfo.pq
```

Name the query:

```text
RefreshInfo
```

Apply the changes to the semantic model.

### 3. Create the DAX Measure

Create a new measure in the `_Measures` table.

Paste the contents of:

```text
dax/WorkdayMonitor.dax
```

Set the measure data category to:

```text
Uncategorized
```

### 4. Create the Report Visual

Add a table visual to the report and place the `Workday Monitor` measure in the visual.

Recommended formatting:

```text
Text wrap: On
Column headers: Off
Tooltips: Off
Horizontal gridlines: Off
Vertical gridlines: Off
Border: Off
Background: Off
```

If the column header remains visible, use `Rename for this visual` and assign an invisible display name.

### 5. Publish the Power BI App

After validating the report:

1. Save the report in the workspace.
2. Include the report in a Power BI app.
3. Configure the app audience.
4. Publish or update the app.

## Design Decisions

### Single Primary DAX Measure

The project intentionally uses one primary DAX measure to demonstrate:

- Variable-based DAX architecture
- Reusable intermediate calculations
- Conditional text output
- Time-zone handling
- Work-schedule logic
- Text-based visual presentation

For a larger production solution, separate numerical measures and native Power BI visuals would provide greater formatting flexibility.

### UTC as the Common Time Reference

UTC is used to provide consistent behavior in Power BI Service.

Both the current timestamp and the semantic model refresh timestamp are converted to Warsaw local time.

### Text-Based Progress Bar

The progress indicator uses ASCII characters:

```text
========------------ 40.0%
```

This approach avoids custom visuals and keeps the report based on one primary DAX measure.

## Known Limitations

- `UTCNOW()` is not a continuously updating clock.
- The displayed current time changes when the visual query is recalculated.
- Polish public holidays are not included.
- Personal leave and custom non-working days are not included.
- Saturday and Sunday are always treated as non-working days.
- Overnight schedules such as `22:00–06:00` are not supported.
- The progress-bar appearance depends on the selected font.
- Individual lines cannot be formatted independently because the combined output is text.
- The refresh timestamp changes only after the `RefreshInfo` query is refreshed.
- The repository contains source code and documentation, not a complete PBIP project definition.

## Potential Future Improvements

- Add a Polish public-holiday calendar
- Support overnight work schedules
- Store work schedule configuration outside the DAX measure
- Add configurable working days
- Add support for personal leave
- Create separate numerical measures for native Power BI visuals
- Add conditional colors for workday status
- Add automated tests for daylight-saving-time transitions
- Convert the solution into a complete PBIP project
- Add automated validation and deployment workflows

## Project Status

```text
Status: Working prototype
Environment: Power BI Service
Model type: Import semantic model
Primary implementation: One DAX measure
Time zone: Europe/Warsaw
Default schedule: 08:00–16:00
```

## License

This project is available under the MIT License.

## Author

Created by Kamil Soszka as a hands-on Power BI, DAX, Power Query M, and TMDL development project.

---

If this project is useful, consider giving the repository a star.
