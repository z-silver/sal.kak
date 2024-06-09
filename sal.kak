# simply aritied lisp

hook global BufCreate .+\.sal(?:em)? %{
  set-option buffer filetype sal
}

hook global BufSetOption filetype=sal %{
  require-module sal
  add-highlighter buffer/sal ref sal
  hook -once -always window BufSetOption filetype=.* %{
    remove-highlighter buffer/sal
  }
}

provide-module sal %§
  add-highlighter -override shared/sal regions
  # separators \s;:"\(\)\[\]\{\}
  # prefixes '',!@\$
  # dispatch #\.
  add-highlighter shared/sal/punctuation default-region \
    regex '[:'',!@\$%#\.\(\)]' 0:keyword

  add-highlighter shared/sal/bareword region \
    '(?<![^\s;:"\(\)\[\]\{\}'',!@\$%])[^\s;:"\(\)\[\]\{\}'',!@\$%#\.]' \
    '(?![^\s;:"\(\)\[\]\{\}])' regex '\.' 0:keyword

  add-highlighter shared/sal/keyword region \
    '(?<![^\s;:"\(\)\[\]\{\}'',!@\$%])\.(?!["\(\[\{])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill string

  # also includes generalized symbols
  add-highlighter shared/sal/string region \
    '(?<![^\s;:"\(\)\[\]\{\}]'',!@\$%)[:]?"' '(?<!\\)(\\\\)*"' regions
  add-highlighter shared/sal/string/def default-region fill string

  add-highlighter shared/sal/string/escape region \
    '(?:\\\\)*\\' '.' fill keyword

  add-highlighter shared/sal/raw-string region \
    '(?<![^\s;:"\(\)\[\]\{\}]'',!@\$%)#"' '"' fill string

  add-highlighter shared/sal/block-comment region -recurse '#\|' \
    '(?<![^\s;:"\(\)\[\]\{\}'',!@\$%])#\|' \
    '(?<!#)\|#' fill comment

  add-highlighter shared/sal/line-comment region \
    ';|(?<![^\s;:"\(\)\[\]\{\}'',!@\$%])#[!l]' \
    '\n' fill comment

  add-highlighter shared/sal/form-comment region \
    '(?<![^\s;:"\(\)\[\]\{\}'',!@\$%])#[_;]' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill comment

  add-highlighter shared/sal/hash region \
    '(?<![^\s;:"\(\)\[\]\{\}'',!@\$%])#(?:\\[\S]?|[^\$_;''"\(\[\{])' \
    '(?![^\s;:"\(\)\[\]\{\}])' regions

  add-highlighter shared/sal/hash/invalid default-region fill Error

  add-highlighter shared/sal/hash/char region \
    '#\\(?:\S|u[0-9a-fA-F]+|space|tab|newline|return)(?![^\s;:"\(\)\[\]\{\}])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/boolean region \
    '#[tf]' '(?![^\s;:"\(\)\[\]\{\}])' regions

  add-highlighter shared/sal/hash/boolean/invalid default-region fill Error

  add-highlighter shared/sal/hash/boolean/true region \
    '#t(?![^\s;:"\(\)\[\]\{\}])' '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/boolean/false region \
    '#f(?![^\s;:"\(\)\[\]\{\}])' '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/binary region \
    '#[bc][+-]?(?:[01_]*\.?[01_]*[01][01_]*(?:/[01_]*\.?[01_]*)?[ijk]?|[ijk])(?:[+-](?:[01_]*\.?[01_]*[01][01_]*(?:/[01_]*\.?[01_]*)?[ijk]?|[ijk]))*(?![^\s;:"\(\)\[\]\{\}])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/seximal region \
    '#s[+-]?(?:[012345_]*\.?[012345_]*[012345][012345_]*(?:/[012345_]*\.?[012345_]*)?[ijk]?|[ijk])(?:[+-](?:[012345_]*\.?[012345_]*[012345][012345_]*(?:/[012345_]*\.?[012345_]*)?[ijk]?|[ijk]))*(?![^\s;:"\(\)\[\]\{\}])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/octal region \
    '#o[+-]?(?:[01234567_]*\.?[01234567_]*[01234567][01234567_]*(?:/[01234567_]*\.?[01234567_]*)?[ijk]?|[ijk])(?:[+-](?:[01234567_]*\.?[01234567_]*[01234567][01234567_]*(?:/[01234567_]*\.?[01234567_]*)?[ijk]?|[ijk]))*(?![^\s;:"\(\)\[\]\{\}])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/decimal region \
    '#d?[+-]?(?:[0123456789_]*\.?[0123456789_]*[0123456789][0123456789_]*(?:/[0123456789_]*\.?[0123456789_]*)?[ijk]?|[ijk])(?:[+-](?:[0123456789_]*\.?[0123456789_]*[0123456789][0123456789_]*(?:/[0123456789_]*\.?[0123456789_]*)?[ijk]?|[ijk]))*(?![^\s;:"\(\)\[\]\{\}])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/dozenal region \
    '#z[+-]?(?:[0123456789aAbBxXeEtT_]*\.?[0123456789aAbBxXeEtT_]*[0123456789aAbBxXeEtT][0123456789aAbBxXeEtT_]*(?:/[0123456789aAbBxXeEtT_]*\.?[0123456789aAbBxXeEtT_]*)?[ijk]?|[ijk])(?:[+-](?:[0123456789aAbBxXeEtT_]*\.?[0123456789aAbBxXeEtT_]*[0123456789aAbBxXeEtT][0123456789aAbBxXeEtT_]*(?:/[0123456789aAbBxXeEtT_]*\.?[0123456789aAbBxXeEtT_]*)?[ijk]?|[ijk]))*(?![^\s;:"\(\)\[\]\{\}])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill value

  add-highlighter shared/sal/hash/hex region \
    '#x[+-]?(?:[0123456789aAbBcCdDeEfF_]*\.?[0123456789aAbBcCdDeEfF_]*[0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF_]*(?:/[0123456789aAbBcCdDeEfF_]*\.?[0123456789aAbBcCdDeEfF_]*)?[ijk]?|[ijk])(?:[+-](?:[0123456789aAbBcCdDeEfF_]*\.?[0123456789aAbBcCdDeEfF_]*[0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF_]*(?:/[0123456789aAbBcCdDeEfF_]*\.?[0123456789aAbBcCdDeEfF_]*)?[ijk]?|[ijk]))*(?![^\s;:"\(\)\[\]\{\}])' \
    '(?![^\s;:"\(\)\[\]\{\}])' fill value
§
