@chcp 65001

call vrunner compile --src=./src/cf --out=./build/tAgents.cf

call vrunner load --src=./build/tAgents.cf

call vrunner updatedb

