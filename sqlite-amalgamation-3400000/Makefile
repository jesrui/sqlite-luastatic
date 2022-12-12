
libsqlite3.a: sqlite3.o
	ar rcs $@ $^
	ranlib $@

.PHONY: clean

clean:
	$(RM) sqlite3.o libsqlite3.a
