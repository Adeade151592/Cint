test:
	cd test && go mod tidy && go test -v -timeout 30m

test-fast:
	cd test && go test -v -timeout 10m -short

clean:
	cd test && go clean -testcache