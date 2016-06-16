#
# SQL.MK --Rules for dealing with SQL files.
#
# Contents:
# %.sql:   --Rules for installing SQL scripts into libdir
# toc-sql: --Build the table-of-contents for SQL files.
# src-sql: --Update the SQL_SRC macro.
# todo:    --Report unfinished work in work SQL files.
#
.PHONY: $(recursive-targets:%=%-sql)

sqllibdir	:= $(exec_prefix)/lib/sql/$(subdir)

#
# %.sql: --Rules for installing SQL scripts into libdir
#
$(sqllibdir)/%.sql:	%.sql;	$(INSTALL_FILE) $? $@

install-sql:    $(SQL_SRC:%=$(sqllibdir)/%)

#
# toc: --Build the table-of-contents for SQL files.
#
toc:	toc-sql
toc-sql:
	$(ECHO_TARGET)
	mk-toc $(SQL_SRC)
#
# src: --Update the SQL_SRC macro.
#
src:	src-sql
src-sql:
	$(ECHO_TARGET)
	@mk-filelist -qn SQL_SRC *.sql

#
# todo: --Report unfinished work in work SQL files.
#
todo:	todo-sql
todo-sql:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(SQL_SRC) /dev/null || true
