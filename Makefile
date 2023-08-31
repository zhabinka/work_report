build:
	mix escript.build

run: build
	./work_report jopa

hello:
	./work_report hello

_run:
	./work_report -m 5 -d 3 test/sample/report-1.md
