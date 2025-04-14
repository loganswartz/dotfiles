-- https://github.com/lttb/gh-actions-language-server/issues/4
return {
    init_options = {
        sessionToken = os.getenv("GITHUB_ACTIONS_LS_TOKEN"),
    },
}
