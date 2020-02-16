# hangtran

### A simple Hangman game written in Fortran

## Motivation

I wrote this little game to teach myself some Fortran basics.
If you're learning a new programming language, I recommend
making a simple word game like this. More complicated games
can tie you down with getting little bugs out of the game logic,
taking time away from learning the language.

## Get started

To install, first clone or download the repository. To
compile the source code, you'll need gfortran or some other
Fortran compiler. A (very) simple makefile is included, so
after you get the files on your system, open the main folder
in your terminal and type `make` to compile.

After you've compiled, type `./hangtran` to start playing. Guess
single letters one at a time until you get all the letters in
the word. You have five guesses per word. A beautifully drawn
ASCII art rendering of a hanged man (without the gallows) will
reveal itself more with each incorrect guess, motivating you
to do your best.

The game will keep track of how many rounds you've won. Keep
playing until you lose (it's surprisingly hard), or type
`CTRL-Z` to quit. I wanted to keep the interface as basic as
possible, so there's no quit function, saved high scores, or
other little niceties.

## Sources

The words in the game are pulled from the top 5000 most common
English words as collected by
[Word Frequency Data](https://www.wordfrequency.info/).
There are other free word lists out there, but that top 5000
list is just big enough to make this game challenging. Giant
word lists containing every known English word might be good
for Scrabble clones, but they make Hangman nearly impossible.

The game only selects words that are at least 5 characters long,
so you're spared having to guess tiny words, which is actually
pretty hard. With those words filtered out, the total number of
words you'll see in the game is obviously less than 5000, but
you'd probably still have to play for a really long time to see
a repeat word.

## Strategies

The game doesn't show you how long the secret word is at first,
so your first guess is a total shot in the dark. I recommend
starting with the
[most frequent letters](https://en.wikipedia.org/wiki/Letter_frequency)
for your first few guesses. After you get a few correct letters,
try reasoning out the rest of the word.
