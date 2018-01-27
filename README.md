# Word Buzzer

* #### How much time was invested

   Overall time invested (not including breaks) is about four hours

* #### How was the time distributed (concept, model layer, view(s), game mechanics)

   Most of the time was invested in the view model.
The view model itself contains all of the game logic, so it only makes sense
that it would require more time. Other than that, the tests did not take as much time, but
I did spend some time thinking about how to test certain things, and how
to mock classes.

* #### Decisions made to solve certain aspects of the game

   1. Using MVVM: this is a default for me by now, as it makes testing a lot easier
   2. Using a dependency injector: this might seem like an overkill for a small app,
   but it did not require a lot of time and it made testing the ViewController much simpler.
   Also, dependency injection is crucial for testing as it allows us to easily use mocks.
   3. Using protocols for every class: this is again done for testing purposes.
   I also do not like using inheritance if I can avoid it, and with swift's protocol extension
   it has become a lot easier to avoid.
   4. Using reactive programming: for me personally it's a lot easier to write
   code this way
   5. Retrieving the json from the global queue: all potentially time consuming tasks
   should not be executed on the main thread.

* #### Decisions made because of restricted time

   1. Not presenting any errors to the users, for example if there was a problem
   parsing the json, the user would not be aware of it as there will be no alert
   informing him.
   2. Second, the UX does not provide enough feedback to the user. For example,
   there's no animation that signals a buzzer was actually tapped. There's also no
   feedback for a wrong buzz, so a user might think that the buzzers are not working.
   3. Currently English and Spanish are 'hard coded' as native/training languages.
   This should be subjected to changes, as different users will want to use
   different languages.

* #### What would be the first thing to improve or add if there had been more time

  I would act according to the list from the previous question.
