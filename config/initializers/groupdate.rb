# Groupdate has limited support for SQLite.

#     No time zone support
#     No day_start option
#     No group_by_quarter method

# If your application’s time zone is set to something other than Etc/UTC (the default), create an initializer with:

Groupdate.time_zone = false
