.PHONY: install clean

APP = HelloWorld

KEYSTORE ?= dev.keystore
PASSWORD ?= password

BUILD_TOOLS = $(ANDROID_HOME)/build-tools/31.0.0
ANDROID_R8 = $(ANDROID_HOME)/cmdline-tools/latest/lib/r8.jar
ANDROID_JAR = $(ANDROID_HOME)/platforms/android-29/android.jar

app: $(APP).apk

install: $(APP).apk
	adb $@ -r --no-incremental $<

$(APP).apk: $(APP).unsigned.apk $(KEYSTORE)
	$(BUILD_TOOLS)/apksigner sign --ks $(KEYSTORE) --ks-pass pass:$(PASSWORD) \
		--in $< --out $@

keystore: $(KEYSTORE)

$(KEYSTORE):
	keytool -genkeypair -validity 10000 \
		-dname "CN=M696E, OU=M696E, O=M696E, C=IR" \
		-keystore $@ -storepass $(PASSWORD) -keypass $(PASSWORD) \
		-deststoretype pkcs12 -keyalg RSA

$(APP).unsigned.apk: AndroidManifest.xml dex/classes.dex
	$(BUILD_TOOLS)/aapt package -f \
		-I $(ANDROID_JAR) -M AndroidManifest.xml -F $@ dex

dex/classes.dex: classes.zip
	mkdir -p dex
	unzip -u $< -d dex

classes.zip: src/MainActivity.class
	java -Xmx2G -classpath $(ANDROID_R8) com.android.tools.r8.D8 \
		--classpath $(ANDROID_JAR) --output $@ $^

src/%.class: src/%.java
	javac -source 1.8 -target 1.8 -classpath $(ANDROID_JAR) $^

clean:
	rm -rf src/*.class classes.zip dex \
		$(APP).unsigned.apk $(APP).apk $(APP).apk.idsig
