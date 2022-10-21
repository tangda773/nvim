local gknapsettings = {
    texoutputext = "pdf",
    textopdf = "xelatex -synctex=1 -halt-on-error -interaction=batchmode %docroot%",
    -- for html
    htmltohtmlviewerlaunch = "live-server --quiet --browser=firefox --open=%outputfile% --watch=%outputfile% --wait=800",
    htmltohtmlviewerrefresh = "none",
    mdtohtmlviewerlaunch = "live-server --quiet --browser=firefox --open=%outputfile% --watch=%outputfile% --wait=800",
    mdtohtmlviewerrefresh = "none",
    -- for pdf
    textopdfviewerlaunch = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,0)\"' --reuse-instance %outputfile%",
    textopdfviewerrefresh = "none",
    textopdfforwardjump = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,0)\"' --reuse-instance --forward-search-file %srcfile% --forward-search-line %line% %outputfile%"
}
vim.g.knap_settings = gknapsettings
