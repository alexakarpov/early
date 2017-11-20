-module(scavenge_urls).
-export([urls2htmlFile/2, bin2urls/1]).

urls2htmlFile(Urls, File) ->
    file:write_file(File, urls2html(Urls)).

urls2html(Urls) ->
    [h1("URLs"), make_list(Urls)].

bin2urls(Bin) ->
    gather_urls(binary_to_list(Bin), []).

h1(Title) ->
    ["<h1>", Title, "</h1>\n"].

make_list(L) ->
    ["<ul>\n",
     lists:map(fun(I) ->
                       ["<li>",I,"</li>\n"] end, L),
     "</ul>\n"].

gather_urls("<a href" ++ T, L) ->
    {Url, T1} = collect_url_body(T, lists:reverse("<a href")),
    gather_urls(T1, [Url|L]);
gather_urls([_|T], L) ->    
    gather_urls(T, L);
gather_urls([], L) ->
    L.

collect_url_body("</a>" ++ T, L) ->
    {lists:reverse(L, "</a>"), T};
collect_url_body([H|T], L) ->
    collect_url_body(T, [H|T]);
collect_url_body([], _) -> {[],[]}.


