! Extract five letter words from words_alpha.txt for use in
! expert_game. easy_game uses a different, smaller word list.
PROGRAM getWords
IMPLICIT NONE
  INTEGER :: reason
  CHARACTER(LEN = 6) :: w
  ! words_alpha.txt contains all English words. Write all words
  ! exactly five characters long to a file called dict.txt
  OPEN(1, FILE = 'words_alpha.txt', STATUS = 'old')
  OPEN(2, FILE = 'dict.txt', STATUS = 'new')
  PRINT *, "FILES OPENED."
  DO
    READ(1, *, IOSTAT = reason) w
    IF (reason > 0) THEN
      PRINT *, "ERROR"
      CLOSE(1)
      EXIT
    ELSE IF (reason < 0) THEN
      PRINT *, "END OF FILE"
      CLOSE(1)
      EXIT
    ELSE
      IF (LEN(TRIM(w)) == 5) THEN
        WRITE(2, *) w
      END IF
    END IF
  END DO
  CLOSE(2)
  PRINT *, "FILES CLOSED."

END PROGRAM getWords
