"""
"""


def _hello_cli_impl(ctx):
    script = [
        "#!/usr/bin/env bash",
        ctx.executable._binary.short_path,
    ]

    script_file = ctx.actions.declare_file("run_" + ctx.label.name)

    ctx.actions.write(
        output = script_file,
        content = "\n".join(script),
    )

    runfiles = ctx.runfiles(files = [])
    runfiles = runfiles.merge(ctx.attr._binary[DefaultInfo].default_runfiles)

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
    },
    doc = "TBD.",
    executable = True,
)
