CurEx (Currency Exchange project)

Enter a value and a currency, select a destination currency and hit the 'equals' button.

Each time you change the source currency, a timer is reset. Any currency calculation that is requested within ten seconds of the timer reset utilizes cached values for calculation. Otherwise rates are re-fetched.

Development considerations:

Because the currency data only changes every 24 hours, I first of all considered caching all of the lists of rates (with Core Data) for the duration of their validity. However, there would be the issue of determining exactly when to do a refresh. So I decided to go with the much simpler solution provided here.

Requires testing
