### Overview
Perf analysis on a Node process inside a Docker container (Ubuntu). Generate a [flame graph](http://www.brendangregg.com/FlameGraphs/cpuflamegraphs.html) representing the Node.js stack of functions to see what is most CPU intensive.

Pulls Ubuntu Docker image. Downloads, install, and builds linux [perf tools](https://en.wikipedia.org/wiki/Perf_(Linux)). Also installs Node.js.

Copies Node.js program into the Docker container. Runs Node program with the [--perf_basic_prof_only_functions](--perf_basic_prof_only_functions) flag.

### On FlameGraphs
<p data-height="378" data-theme-id="light" data-slug-hash="rLYGQN" data-default-tab="result" data-user="hzhu" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/hzhu/pen/rLYGQN/">Flame Graph</a> by Henry Zhu (<a href="http://codepen.io/hzhu">@hzhu</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

* A large height of the stack isn't necessiarily bad.
* The width of a stack frame indicates the total time it was on-CPU and long stack frame might need to be looked into.
* The colors aren't significant, and are usually picked at random to be warm colors (other meaningful palettes are supported).

### Requirements
* [Docker](https://docs.docker.com/engine/installation/)

### Getting Started
1) Build Docker Image
```
docker build -t my-nodejs-app .
```

2) Run Docker container & enable CAP_SYS_ADMIN to run `perf`
```
docker run --cap-add=SYS_ADMIN -i -t -p 8080:8080 my-nodejs-app
```

3) Create a new Bash session in the container
```
docker exec -it <container id> /bin/bash
```

4) Run a command and record its profile into perf.data for 30 seconds
`-p` to record events on existing process id
`-F 99` profile at this frequency
```
sudo perf record -F 99 -p `pgrep -n node` -g -- sleep 30
```

5) Generate nodestacks file
```
perf script > nodestacks
```


6) Make nodestacks file human readable
```
sed -i '/\[unknown\]/d' nodestacks
```

7) Generate FlameGraph
```
git clone --depth 1 http://github.com/brendangregg/FlameGraph
cd FlameGraph
./stackcollapse-perf.pl < ../nodestacks | ./flamegraph.pl --colors js > ../node-flamegraph.svg
```