return {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    opts = {
        open_cmd = 'zen-beta -private-window %s',
        extra_args = { "--verbose" },
        dependencies_bin = {
            tinymist = 'TINYMIST',
            websocat = 'WEBSOCAT',
        },
    },
}
