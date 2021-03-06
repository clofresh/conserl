PROJECT=conserl
REBAR=./rebar

all: compile

build-plt: all
	@dialyzer --build_plt --output_plt ~/.$(PROJECT).plt \
		--apps kernel stdlib sasl erts ssl \
				tools os_mon runtime_tools crypto \
				inets xmerl webtool snmp public_key \
				mnesia syntax_tools compiler \
				./deps/*/ebin

check-plt:
	@dialyzer --check_plt --plt ~/.$(PROJECT).plt

clean:
	@echo "Running rebar clean..."
	@$(REBAR) clean
	@rm -rf deps ebin

compile:
	@echo "Running rebar compile..."
	@$(REBAR) compile

deps:
	@echo "Running rebar get-deps..."
	@$(REBAR) get-deps

dialyze:
	@dialyzer ebin/*.beam --plt ~/.$(PROJECT).plt -I include

doc: compile
	@echo "Running rebar doc..."
	@$(REBAR) skip_deps=true doc

eunit:
	@echo "Running rebar eunit..."
	@$(REBAR) skip_deps=true eunit

console:
	@( erl +W w -pa ebin deps/*/ebin -config app.config -sync log all -s conserl)

test: all eunit

xref:
	@$(REBAR) skip_deps=true xref

.PHONY: dialyze doc eunit xref
