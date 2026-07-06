return {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    opts = {
        open_cmd = 'brave --app=%s',
        extra_args = { "--verbose" },
        dependencies_bin = {
            tinymist = 'TINYMIST',
            websocat = 'WEBSOCAT',
        },
    },
}
