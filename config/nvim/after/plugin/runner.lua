require('code_runner').setup({
    filetype = {
        python = "python3 -u",
        c = "cc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
    },
    project = {
        ["~/src/inventario_web/bin"] = {
        name = "Inventario web",
        command = "dune exec inventario_web"},
        ["~/src/inventario_ui"] = {
        name = "Inventario ui",
        command = "dune exec inventario_ui"}
    },
})
