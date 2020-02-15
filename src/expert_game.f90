! In expert mode, letters are not guessed one at a time. Entire
! words are guessed, and correct letters are shown. This mode
! exists only as a draft.
MODULE tools
IMPLICIT NONE
CONTAINS
  FUNCTION GET_RANDOM_WORD(arr)
    CHARACTER*5, DIMENSION(:), INTENT(IN) :: arr
    CHARACTER(LEN = 5) :: GET_RANDOM_WORD
    INTEGER :: index
    index = CEILING(RAND(0) * SIZE(arr))
    GET_RANDOM_WORD = arr(index)
  END FUNCTION GET_RANDOM_WORD

  FUNCTION GET_USER_INPUT()
    CHARACTER(LEN = 5) :: GET_USER_INPUT
    READ *, GET_USER_INPUT
  END FUNCTION GET_USER_INPUT
END MODULE

PROGRAM game
USE tools
IMPLICIT NONE
  INTEGER :: i = 1, reason = 0, lines = 0, guess_count = 0, score = 0
  CHARACTER :: w
  CHARACTER(LEN = 5), DIMENSION(:), ALLOCATABLE :: words(:)
  CHARACTER(LEN = 5) :: secret, guess, show_correct

  CHARACTER*5, DIMENSION(1:5) :: draw_man
  draw_man(1) = " ( ) "
  draw_man(2) = "/`|`\"
  draw_man(3) = " _|_ "
  draw_man(4) = " | | "
  draw_man(5) = "_| |_"

  OPEN(1, FILE = "../resources/dict.txt", STATUS = 'old')

  ! Get the length of dict.txt
  lines = 0
  DO WHILE (reason == 0)
    lines = lines + 1
    READ(1, *, IOSTAT = reason) w
  END DO
  lines = lines - 1

  ! Use dict.txt to fill an array of words
  ALLOCATE(words(lines))
  REWIND(1)
  DO i = 1, lines
    READ(1, *) words(i)
  END DO

  CALL SYSTEM_CLOCK(i)
  CALL SRAND(i)

  secret = GET_RANDOM_WORD(words)
  !PRINT *, secret
  guess = GET_USER_INPUT()

  DO WHILE ((guess .ne. secret) .and. (guess_count .lt. 5))
    ! Show correct letters
    DO i = 1, 5
      IF (secret(i:i) .eq. guess(i:i)) THEN
        show_correct(i:i) = secret(i:i)
      ELSE
        show_correct(i: i) = '_'
      END IF
    END DO
    PRINT *, show_correct
    ! Draw the hangman
    guess_count = guess_count + 1
    DO i = 1, 5
      IF (i .le. guess_count) THEN
        PRINT *, draw_man(i)
      ELSE
        PRINT *, ""
      END IF
    END DO

    ! Get a new guess or say "you lose"
    IF (guess_count .lt. 5) THEN
      guess = GET_USER_INPUT()
    ELSE
      PRINT *, "YOU LOSE"
    END IF
  END DO

  DEALLOCATE(words)
  CLOSE(1)
END PROGRAM game
