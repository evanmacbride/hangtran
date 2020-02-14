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
  INTEGER :: i = 1, reason = 0, lines = 0
  CHARACTER :: w
  CHARACTER(LEN = 5), DIMENSION(:), ALLOCATABLE :: words(:)
  CHARACTER(LEN = 5) :: secret, guess, display

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
  PRINT *, secret
  guess = GET_USER_INPUT()

  DO WHILE (guess .ne. secret)
    DO i = 1, 5
      IF (secret(i:i) .eq. guess(i:i)) THEN
        display(i:i) = secret(i:i)
      ELSE
        display(i: i) = '_'
      END IF
    END DO
    PRINT *, display
    guess = GET_USER_INPUT()
  END DO

  DEALLOCATE(words)
  CLOSE(1)
END PROGRAM game
