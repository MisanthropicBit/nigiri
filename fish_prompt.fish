# Modified theme of oh-my-fish's default theme
#
# You can override some default options with config.fish:
#
# Shorten the parts of the path except the last one
#   set -g theme_short_path (yes|no)
#
# Show a house emoji when in the home directory
#   set -g theme_emoji_home (yes|no)

function echo_last_return_value -a last_command_status -d 'Echo the last exit code with a format'
    if test "$last_command_status" -ne 0
        echo -n " "(set_color brred)"($last_command_status)"(set_color normal)
    end
end

function echo_user -a root fish last_command_status sushi -d 'Echo user fish'
    if test $last_command_status -eq 0
        if test (id -u) -eq 0
            set user "$root"
        else
            set user "$fish"
        end

        echo -ns "$user "
    else
        echo -ns "$sushi "
    end
end

function echo_cwd -a cwd directory_color -d 'Echo the current working directory'
    if test "$theme_short_path" = "yes"
        set -l root_folder (command git rev-parse --show-toplevel 2> /dev/null)
        set -l parent_root_folder (dirname $root_folder)
        set -l cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    end

    if test "$cwd" = "~" -a "$theme_emoji_home" = "yes"
        echo -n " 🏡 "
    else
        echo -n " $directory_color$cwd"(set_color normal)
    end
end

function echo_git_ahead -a ahead behind diverged none -d 'Echo git ahead/behind'
    set -l commit_count (command git rev-list --count --left-right "@{upstream}...HEAD" 2> /dev/null)

    switch "$commit_count"
        case ""
            # no upstream
        case "0"\t"0"
            echo "$none"
        case "*"\t"0"
            set -l behind_count (string match --regex '^\\d+' "$commit_count")
            echo "$behind$behind_count"
        case "0"\t"*"
            set -l ahead_count (string match --regex '\\d+$' "$commit_count")
            echo "$ahead$ahead_count"
        case "*"
            echo "$diverged"
    end
end

function git_is_repo -d "Check if directory is a repository"
    test -d .git; or command git rev-parse --git-dir >/dev/null 2> /dev/null
end

function git_branch_name -d "Get current branch name"
    git symbolic-ref --short HEAD 2> /dev/null; or git show-ref --head -s --abbrev | head -n1 2> /dev/null
end

function git_branch_commit -d "Get the commit of the current HEAD"
    git rev-parse --short HEAD
end

function git_is_dirty -d "Check if there are changes to tracked files"
    not git diff --no-ext-diff --quiet
end

function git_is_staged -d "Check if repo has staged changes"
    not git diff --cached --no-ext-diff --quiet --exit-code
end

function git_is_stashed -d "Check if repo has stashed contents"
    git rev-parse --verify --quiet refs/stash >/dev/null
end

function fish_prompt
    set -l last_command_status $status
    set -l cwd

    if test "$theme_short_path" = 'yes'
        set cwd (basename (prompt_pwd))
    else
        set cwd (prompt_pwd)
    end

    set -l fish     "🐠"
    set -l root     "🦈"
    set -l sushi    "🍣"
    set -l clean
    set -l ahead
    set -l behind
    set -l diverged
    set -l stashed
    set -l staged
    set -l dirty
    set -l none
    set -l job

    if [ "$theme_nerd_fonts" = "yes" ]
        set clean    ""
        set ahead    ""
        set behind   ""
        set diverged ""
        set stashed  ""
        set staged   ""
        set dirty    ""
        set none     ""
        set job      ""
    else
        set clean    "✓"
        set ahead    "↑"
        set behind   "↓"
        set diverged "⥄ "
        set stashed  "⁕"
        set staged   "●"
        set dirty    "×"
        set none     "◦"
        set job      "⚡"
    end

    echo_user "$root" "$fish" "$last_command_status" "$sushi"
    echo_last_return_value "$last_command_status"
    echo_cwd $cwd $directory_color

    set -l job_count (jobs | wc -l | string trim -lr)

    if test "$job_count" -gt 0
        echo -ns " $job_color("(jobs | wc -l | string trim -lr)")$normal_color"
    end

    if git_is_repo
        echo -ns " on " $repository_color (git_branch_name) "[" $repo_commit_color (git_branch_commit) $repository_color "]" $normal_color " "

        set -l git_status (echo_git_ahead\
                           "$git_ahead_color$ahead"\
                           "$git_behind_color$behind"\
                           "$git_diverged_color$diverged")

        # Set git markers
        git_is_dirty; and set -a markers "$git_dirty_color$dirty"; or set -a markers "$success_color$clean"
        git_is_stashed; and set -a markers "$git_stashed_color$stashed"
        git_is_staged; and set -a markers "$git_staged_color$staged"
        test -n "$git_status"; and set -a markers "$git_status"

        echo -ns $normal_color "[$markers$normal_color]"
    end

    echo -ns " "
end
