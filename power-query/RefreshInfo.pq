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
