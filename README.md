### Overview
An attempt to do perf analysis on a Node process inside a Docker container (Ubuntu).

Run Docker container & enable CAP_SYS_ADMIN to run `perf`
`docker run --cap-add=SYS_ADMIN -i -t -p 8080:8080 my-nodejs-app`

SSH into container
```
docker exec -it <container id>
```

Use this command inside container to perf to generate stack trace (Must beat server with requests during these 30 seconds)
```
perf record -F 99 -p `pgrep -n node` -g -- sleep 30
```

Output Node stack and generate flame graph
```
perf script > out.nodestacks01
git clone --depth 1 http://github.com/brendangregg/FlameGraph
cd FlameGraph
./stackcollapse-perf.pl < ../out.nodestacks01 | ./flamegraph.pl > ../out.nodestacks01.svg`
```