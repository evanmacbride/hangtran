PROGRAM game
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
    index = CEILING(RAND(0) * lines)
    PRINT *, words(index)
  END DO

  DEALLOCATE(words)
  CLOSE(1)
END PROGRAM game
