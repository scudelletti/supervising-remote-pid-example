### Supervising Remote PIDs Proof of Concept
This repo is just a proof of concept of supervising remote PIDs

#### Note

There's a "simpler" version without the Link GenServer in the `simple` branch, but it does not work well with `System.stop` when its run in the node holding the remote PID.

#### Start Node A:
```
iex --name a@127.0.0.1 --erl "-config sys.config" -S mix
```

#### Start Node B:
```
iex --name b@127.0.0.1 --erl "-config sys.config" -S mix
```

#### Check where and if the GenServer is running
```
:global.whereis_name(Blue.File)
```

#### Watch tmp list of files folder
```
watch "ls -l tmp"
```

#### Create a file in Node A
```
Blue.File.write("1")
```

#### Create a file in Node B
```
Blue.File.write("2")
```

#### Kill the node running the GenServer.

#### Create a new file in living Node
```
Blue.File.write("3")
```
