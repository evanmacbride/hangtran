MODULE word_tools
IMPLICIT NONE
CONTAINS
  FUNCTION GET_RANDOM_WORD(arr)
    CHARACTER*5, DIMENSION(:), INTENT(IN) :: arr
    CHARACTER(LEN = 5) :: GET_RANDOM_WORD
    INTEGER :: index
    index = CEILING(RAND(0) * SIZE(arr))
    GET_RANDOM_WORD = arr(index)
  END FUNCTION GET_RANDOM_WORD
END MODULE

PROGRAM game
USE word_tools
IMPLICIT NONE
  INTEGER :: i, reason, lines, index
  CHARACTER :: w
  CHARACTER(LEN = 5), DIMENSION(:), ALLOCATABLE :: words(:)

  OPEN(1, FILE = "../tools/dict.txt", STATUS = 'old')

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

  ! Print some random words
  DO i = 1, 5
    PRINT *, GET_RANDOM_WORD(words)
  END DO

  DEALLOCATE(words)
  CLOSE(1)
END PROGRAM game
