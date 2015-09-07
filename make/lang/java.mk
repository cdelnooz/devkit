#
# JAVA.MK --Rules for building JAVA objects and programs.
#
# Contents:
# %.class: --Compile a java file into an arch-specific sub-directory.
# build:   --Compile all the JAV_SRC files.
# clean:   --Remove The Java package.
# src:     --Update the JAVA_SRC macro.
# tags:    --Build vi, emacs tags files.
# todo:    --Report "unfinished work" comments in Java files.
#
# Remarks:
# The "lang/java" module provides support for the "java" programming language.
# It requires the following variables to be defined:
#
#  * JAVA_SRC	--java source files
#  * PACKAGE	--the java package name
#
.PHONY: $(recursive-targets:%=%-java)

JAVAC	= javac
JAVA_FLAGS = $(OS.JAVA_FLAGS) $(ARCH.JAVA_FLAGS) $(LOCAL.JAVA_FLAGS) $(TARGET.JAVA_FLAGS)

JAVA_OBJ	= $(JAVA_SRC:%.java=$(archdir)/%.class)

#
# %.class: --Compile a java file into an arch-specific sub-directory.
#
# Remarks:
# ".class" files are arch-neutral aren't they?
#
$(archdir)/%.class: %.java mkdir[$(archdir)] var_defined[PACKAGE]
	$(ECHO_TARGET)
	$(JAVAC) $(JAVA_FLAGS) -d $(archdir) $*.java

#
# build: --Compile all the JAV_SRC files.
#
build:	$(JAVA_OBJ) var-defined[JAVA_SRC]

#
# clean: --Remove The Java package.
#
distclean:	clean-java
clean:	clean-java
clean-java:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(PACKAGE)

#
# src: --Update the JAVA_SRC macro.
#
src:	src-java
src-java:
	$(ECHO_TARGET)
	@mk-filelist -qn JAVA_SRC $(find * -name *.java)
#
# tags: --Build vi, emacs tags files.
#
tags:	tags-java
tags-java:
	$(ECHO_TARGET)
	ctags $(JAVA_SRC) && \
	etags $(JAVA_SRC); true

#
# todo: --Report "unfinished work" comments in Java files.
#
todo:	todo-java
todo-java:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(JAVA_SRC) /dev/null || true
