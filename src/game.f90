MODULE tools
IMPLICIT NONE
CONTAINS
  FUNCTION GET_RANDOM_WORD(arr)
    CHARACTER*32, DIMENSION(:), INTENT(IN) :: arr
    CHARACTER(LEN = 32) :: GET_RANDOM_WORD
    INTEGER :: index
    index = CEILING(RAND(0) * SIZE(arr))
    GET_RANDOM_WORD = arr(index)
  END FUNCTION GET_RANDOM_WORD

  FUNCTION GET_USER_INPUT()
    CHARACTER(LEN = 5) :: GET_USER_INPUT
    PRINT *, "Guess a letter:"
    READ *, GET_USER_INPUT
  END FUNCTION GET_USER_INPUT
END MODULE

PROGRAM game
USE tools
IMPLICIT NONE
  INTEGER :: i = 1, reason = 0, lines = 0, num_wrong = 0, round = 1
  CHARACTER :: w, guess
  CHARACTER(LEN = 32), DIMENSION(:), ALLOCATABLE :: words(:)
  CHARACTER(LEN = 32) :: pick
  CHARACTER(LEN = :), ALLOCATABLE :: secret, correct_letters
  LOGICAL :: guessed_right, won_round, lost_game

  ! Beautiful ASCII art of the hanged man, sans gallows.
  CHARACTER*5, DIMENSION(1:5) :: draw_man
  draw_man(1) = " ( ) "
  draw_man(2) = "/`|`\"
  draw_man(3) = " _|_ "
  draw_man(4) = " | | "
  draw_man(5) = "_| |_"

  ! Use a list of the top 5000 most common English words for
  ! secret words to guess.
  OPEN(1, FILE = "resources/top_5000.txt", STATUS = 'old')

  ! Get the length of word list.
  lines = 0
  DO WHILE (reason == 0)
    lines = lines + 1
    READ(1, *, IOSTAT = reason) w
  END DO
  lines = lines - 1

  ! Use word list to fill an array of words.
  ALLOCATE(words(lines))
  REWIND(1)
  DO i = 1, lines
    READ(1, *) words(i)
  END DO

  ! Seed random number generator with current time.
  CALL SYSTEM_CLOCK(i)
  CALL SRAND(i)

  ! The game loop
  DO WHILE (.not. lost_game)
    ! Display current round.
    PRINT 100, round
    100 FORMAT('ROUND', 1I2)
    ! Pick a secret word and get a guess character from the user.
    ! Keep picking words until desired length is reached.
    DO
      pick = GET_RANDOM_WORD(words)
      IF (LEN(TRIM(pick)) .gt. 4) THEN
        EXIT
      END IF
    END DO
    ! Reallocate strings if this isn't the first round.
    IF (ALLOCATED(secret)) THEN
      DEALLOCATE(secret)
      DEALLOCATE(correct_letters)
    END IF
    ALLOCATE(CHARACTER(LEN=LEN(TRIM(PICK))) :: secret)
    secret = TRIM(pick)
    guess = GET_USER_INPUT()

    ! Initialize correct_letters to blanks the length of secret
    ALLOCATE(CHARACTER(LEN=LEN(secret)) :: correct_letters)
    DO i = 1, LEN(correct_letters)
      correct_letters(i:i) = '_'
    END DO

    ! The round loop
    won_round = .false.
    DO WHILE ((guess .ne. secret) .and. (num_wrong .lt. 5) .and. (.not. won_round))
      guessed_right = .false.
      ! Check if guessed letter is in secret. Fill in
      ! correct_letters at the same time.
      DO i = 1, LEN(secret)
        IF (secret(i:i) .eq. guess) THEN
          correct_letters(i:i) = secret(i:i)
          guessed_right = .true.
        END IF
      END DO

      ! If no letters in secret matched user's guess, increment
      ! num_wrong by 1.
      IF (.not. guessed_right) THEN
        num_wrong = num_wrong + 1
      END IF

      ! Show correctly guessed letters.
      PRINT *, ""
      PRINT *, correct_letters
      PRINT *, ""
      ! Update the picture of the hanged man.
      DO i = 1, 5
        IF (i .le. num_wrong) THEN
          PRINT *, draw_man(i)
        ELSE
          PRINT *, ""
        END IF
      END DO

      won_round = .true.
      ! Check if all letters have been filled in.
      DO i = 1, LEN(correct_letters)
        IF (correct_letters(i:i) .eq. '_') THEN
          won_round = .false.
        END IF
      END DO

      ! Get a new guess, win round, or lose game. Update game
      ! variables as appropriate.
      IF ((num_wrong .lt. 5) .and. (.not. won_round)) THEN
        guess = GET_USER_INPUT()
      ELSE IF (num_wrong .ge. 5) THEN
        PRINT *, ""
        PRINT *, secret
        PRINT *, ""
        PRINT *, "YOU LOSE"
        lost_game = .true.
      ELSE IF (won_round) THEN
        PRINT *, ""
        PRINT *, "CORRECT!"
        PRINT *, ""
        round = round + 1
        num_wrong = 0
      END IF
    END DO
  END DO

  DEALLOCATE(words)
  CLOSE(1)
END PROGRAM game
