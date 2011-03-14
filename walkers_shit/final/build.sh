#!/bin/sh
rm GenFrame\$* GenFrame.class
javac GenFrame.java
jar cfm Gen.jar manifest.txt *.class
