CLASSPATH="src:libs/sqlite-jdbc-3.7.2.jar"

LUKE_GWTPATH="/home/luke/Downloads/gwt-2.6.0"
LUKEWIN_GWTPATH="C\:/Users/luke/Downloads/gwt-2.6.0"
PETER_GWTPATH="i dunno"
AISHIAH_GWTPATH="this is for you"
LEON_GWTPATH="to fill in, not me."
MIKE_GWTPATH="/home/Mike/gwt-2.6.0"
LOUIS_GWTPATH="/home/louis/gwt-2.6.0"
LOUISWIN_GWTPATH="C\:/gwt-2.6.0"

ifeq ($(HOSTNAME), slowbox)
	GWTPATH=$(LUKEWIN_GWTPATH)
else ifeq ($(USERNAME), teum)
	GWTPATH=$(LUKE_GWTPATH)
else ifeq ($(USERNAME), louis)
	GWTPATH=$(LOUIS_GWTPATH)
else ifeq ($(USERNAME), Administrator)
	GWTPATH=$(LOUISWIN_GWTPATH)
else ifeq ($(USERNAME), Mike)
	GWTPATH=$(MIKE_GWTPATH)
else
	GWTPATH="SET YO GODDAMN PATH"
endif

all : clean web rserver config doc pdf manual website
	@echo ""
	@echo "              **************************"
	@echo "              successfully built project"
	@echo "              **************************"
	@echo ""
	@echo "         ------------------------------------"
	@echo "        /  ::PROGRAMMER'S TIP 103::          \\"
	@echo "        |  Breaking the build upsets the     |"
	@echo "        |  turtle. Good job getting the damn |"
	@echo "        |  thing to compile.                 |"
	@echo "        \                                    /"
	@echo "         ---------  -------------------------"
	@echo "                  \|"
	@echo ""
	@echo "                  ------       /^^---^^---^^\\"
	@echo "                / o  o   \    /___/____|_____\\"
	@echo "                \  w     /   /___ /_____|_____\ >"
	@echo "                   -----     u              u"
	@make test


web : config
	@echo ""
	@echo "              ----------------------"
	@echo "              building web interface"
	@echo "              ----------------------"
	sed -e `echo 's:___GWTPATH___:'$(GWTPATH)':g'` web_interface/protobuild.xml > web_interface/build.xml
	ant -f web_interface/build.xml build
	rm web_interface/build.xml
	@echo "              *********************************"
	@echo "              successfully built web interface "
	@echo "              *********************************"

rserver : config
	@echo ""
	@echo "              ----------------------"
	@echo "              building remote server"
	@echo "              ----------------------"
	javac -cp $(CLASSPATH) src/ballmerpeak/turtlenet/remoteserver/*.java
	@echo "              *******************************"
	@echo "              successfuly built remote server"
	@echo "              *******************************"
	
testing : config
	@echo ""
	@echo "              --------------"
	@echo "              Building Tests"
	@echo "              --------------"
	javac -cp $(CLASSPATH) src/ballmerpeak/turtlenet/testing/*.java
	@echo "              ***********************"
	@echo "              successfuly built tests"
	@echo "              ***********************"

test : testing
	@echo ""
	java -cp $(CLASSPATH) ballmerpeak.turtlenet.testing.Test

clean : config
	@echo ""
	@echo "              --------"
	@echo "              Cleaning"
	@echo "              --------"
	sed -e `echo 's:___GWTPATH___:'$(GWTPATH)':g'` web_interface/protobuild.xml > web_interface/build.xml
	rm -f src/ballmerpeak/turtlenet/*/*.class
	rm -f src/ballmerpeak/turtlenet/remoteserver/Message.java
	ant -f web_interface/build.xml clean
	rm web_interface/build.xml
	rm -rf db
	rm -rf web_interface/db
	rm -rf data
	rm -rf testfile
	make -C doc/latex clean
	make -C user_manual clean
	make -C writeup clean
	@echo "              *******"
	@echo "              Cleaned"
	@echo "              *******"

run_server : config
	mkdir -p data
	java -cp $(CLASSPATH) ballmerpeak.turtlenet.remoteserver.Server

winstone_client : config test
	./build.sh

run_client : config
	sed -e `echo 's:___GWTPATH___:'$(GWTPATH)':g'` web_interface/protobuild.xml > web_interface/build.xml
	ant -f web_interface/build.xml clean
	ant -f web_interface/build.xml devmode
	rm web_interface/build.xml

run_headlessclient : config
	javac -cp $(CLASSPATH) src/ballmerpeak/turtlenet/*/*.java
	java -cp $(CLASSPATH) ballmerpeak.turtlenet.server.TNClient

config:
	@echo "GWTPath: $(GWTPATH)"
	@echo "Classpath: $(CLASSPATH)"

doc:
	doxygen doxyfile
	make -C doc/latex

pdf:
	make -C writeup

manual:
	make -C user_manual

website : doc
	cp -r doc/html turtlenet_website/doc
