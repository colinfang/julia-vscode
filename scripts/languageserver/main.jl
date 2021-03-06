conn = STDOUT
(outRead, outWrite) = redirect_stdout()

if VERSION < v"0.5"
    error("VS Code julia language server only works with julia 0.5 or newer.")
end

include("dependencies.jl")
use_and_install_dependencies([
    ("Compat", v"0.9.4"),
    ("JSON", v"0.8.0"),
    ("Lint", v"0.2.5"),
    ("URIParser", v"0.1.6")])

if length(Base.ARGS)!=2
    error("Invalid number of arguments passed to julia language server.")
end

push!(LOAD_PATH, Base.ARGS[1])

if Base.ARGS[2]=="--debug=no"
    const global ls_debug_mode = false
elseif Base.ARGS[2]=="--debug=yes"
    const global ls_debug_mode = true
end

include("jsonrpc.jl")
importall JSONRPC
include("protocol.jl")
include("languageserver.jl")
include("parse.jl")
include("provider_diagnostics.jl")
include("provider_misc.jl")
include("provider_hover.jl")
include("provider_completions.jl")
include("provider_definitions.jl")
include("provider_signatures.jl")
include("transport.jl")
include("provider_symbols.jl")
include("utilities.jl")

server = LanguageServer(STDIN,conn)
run(server)
