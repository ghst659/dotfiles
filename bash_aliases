# -*-shell-script-*-
function join_by {
    local IFS=$1
    shift
    echo "$*"
}

function prepend {
    local prefix=$1
    shift
    for x in $@; do
	echo ${prefix}${x}
    done
}

function append {
    local suffix=$1
    shift
    for x in $@; do
	echo ${x}${suffix}
    done
}
##############################################################################
if [[ -z ${saved_path_stack+x} ]]; then
    declare -a saved_path_stack=( ${PATH} )
fi

function pop_path {
    if [[ ! -z ${saved_path_stack+x} ]]; then
	export PATH=${saved_path_stack[${#saved_path_stack[@]}-1]}
	if (( ${#saved_path_stack[@]} > 1 )); then
	    unset 'saved_path_stack[${#saved_path_stack[@]}-1]'
	fi
    fi
}

function push_path {
    saved_path_stack+=( ${PATH} )
    export PATH="$1"
}

alias rsr=pop_path

function psr {
    local IFS=":"
    set -f
    local -a path_ary=( ${PATH} )
    set +f
    printf "%s\n" "${path_ary[@]}"
}

function asr {
    local -a new_path=()
    local -a path_ary=( $(psr) )
    local -a additions=( $* )
    for a in ${additions[@]}; do
	local include=1
	for p in ${path_ary[@]}; do
	    if [[ "$a" == "${p}" ]]; then
		include=0
		break
	    fi
	done
	if (( ${include} )); then
	    new_path+=( ${a} )
	fi
    done
    for p in ${path_ary[@]}; do
	new_path+=( ${p} )
    done
    local npath=$(join_by : ${new_path[@]})
    push_path ${npath}
}
##############################################################################
function nulio {
    if (( $# > 0 )); then
	( eval $* ) >&/dev/null </dev/null
    fi
}
##############################################################################
function pyenv {
    if (( $# == 1)); then
	local venv=$1
	local act="${venv}/bin/activate"
	if [[ -d ${venv} && -f ${act} ]]; then
	    source ${act}
	else
	    echo "invalid virtual env: ${workspace}" >/dev/stderr
	fi
    else
	echo "usage: pyenv VENVDIR" >/dev/stderr
    fi
}

function gopath {
    if (( $# > 0 )); then
	local workspace=$1
	if [[ -d ${workspace} ]]; then
	    pushd ${workspace}
	    export GOPATH=$(pwd)
	    for subdir in "src" "pkg" "bin"; do
		if [[ ! -d ${subdir} ]]; then
		    mkdir ${subdir}
		else
		    echo "info: ${subdir} exists" >/dev/stderr
		fi
	    done
	    asr ${GOPATH}/bin
	else
	    echo "error: illegal workspace dir: ${workspace}" >/dev/stderr
	fi
    else
	echo "usage: gowork WORKSPACE" >/dev/stderr
    fi
}

# Local Variables:
# mode: shell-script
# End:
