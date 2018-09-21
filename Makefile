compile:
	javac -classpath ".:/Users/ruanpienaar/.kerl/builds/20.3/otp_src_20.3/lib/jinterface/priv/OtpErlang.jar" CounterServer.java
	erlc -Ddebug_info erlang_client.erl