"""
"""


def _hello_cli_impl(ctx):
    script = [
        "#!/usr/bin/env bash",
        """
# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
source "$0.runfiles/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
{ echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---""",
        ctx.executable._binary.short_path
    ]

    script_file = ctx.actions.declare_file("run_" + ctx.label.name)

    ctx.actions.write(
        output = script_file,
        content = "\n".join(script),
    )

    runfiles = ctx.runfiles(files = [])
    runfiles = runfiles.merge(ctx.attr._binary[DefaultInfo].default_runfiles)
    runfiles = runfiles.merge(ctx.attr._bash_runfiles[DefaultInfo].default_runfiles)


    return [DefaultInfo(
        executable = script_file,
        runfiles = runfiles,
    )]

hello_cli = rule(
    implementation = _hello_cli_impl,
    attrs = {
        "_binary": attr.label(
            default = Label("@test//cli-js:bin"),
            executable = True,
            cfg = "exec",
        ),
        "_bash_runfiles" : attr.label(
            default = Label("@bazel_tools//tools/bash/runfiles")
        )
    },
    doc = "TBD.",
    executable = True,
)
