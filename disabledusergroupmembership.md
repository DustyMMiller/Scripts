This will go through AD and pull all disabled user accounts.  It will then create a csv file reporting each group those users are members of, remove them from the groups, and finally report the users and groups at the end.  This is great for making sure that all security/exchange groups only have active users in them.

Make sure to either put in an AD path in the searchbase variable or remove the searchbase from $disabledusers before running.
