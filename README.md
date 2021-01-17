# haskell-polysemy-example

Here you'll find a very simple implementation of a custom effect (over IO) with Polysemy.

Program play with question/answer (automated) and interpret the effect to call the right function.

The goal here is not to make you polysemy fluent but to understand the purpose of the library and to be production ready with it so the example is simple and doesn't cover everything.

A strong strength of polysemy is that you can mocked your effect in during testing.
What does it mean? It means that if you have an IO effet calling a database, wrap it into a polysemy effect, lets say DatabaseEffect, and during you're test you will be able to "replace" the DB by a custom function providing the data.

For me it's THE thing about polysemy, you can now play with impure function during your tests!

## Execution

```script
stack run
```

## Testing

```script
stack test
```

## Coverage

```script
stack clean --full && stack test --coverage
```