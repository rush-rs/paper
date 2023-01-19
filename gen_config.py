# Script to generate a tree-sitter config file
# using the `onedark.nvim` light theme colors

import re
import requests
import json

colors_map = {
    'Fg': 'fg',
    'LightGrey': 'light_grey',
    'Grey': 'grey',
    'Red': 'red',
    'Cyan': 'cyan',
    'Yellow': 'yellow',
    'Orange': 'orange',
    'Green': 'green',
    'Blue': 'blue',
    'Purple': 'purple',
}
code_style = {
    'comments': 'italic',
    'keywords': None,
    'functions': None,
    'strings': None,
    'variables': None,
}
allowed_fmts = ['italic', 'bold', 'underline', 'strikethrough']
additional_keys = {
    'string.special.grammar': '#c18401',
    'symbol.grammar.pascal': '#986801',
    'symbol.grammar.camel': '#0184bc',
    'symbol.grammar.upper': '#c18401',
    'symbol.grammar.lower': '#e45649',
}

groups_re = re.compile(
    r'\["@([\w.]+)"\]\s*=\s*(?:colors\.(\w+)|\{fg\s*=\s*c\.(\w+),\s*fmt\s*=\s*(?:cfg.code_style.(\w+)|(["'
    + r"'])(.*)\5)\})"
)
colors_re = re.compile(r'(\w+) = "(#[a-fA-F0-9]{6})",')

print("Fetching `highlights.lua`...")
highlights_lua = requests.get(
    'https://raw.githubusercontent.com/navarasu/onedark.nvim/master/lua/onedark/highlights.lua'
).text


print("Fetching `palette.lua`...")
palette_lua = requests.get(
    'https://raw.githubusercontent.com/navarasu/onedark.nvim/master/lua/onedark/palette.lua'
).text

print("Fetching complete")

colors = {
    match.group(1): match.group(2)
    for match in colors_re.finditer(
        palette_lua.split('light = {')[1].split('}')[0]
    )
}

theme = {}

for match in groups_re.finditer(highlights_lua):
    if match.group(2) is not None:
        theme[match.group(1)] = colors[colors_map[match.group(2)]]
    elif (
        match.group(4) is not None and code_style[match.group(4)] is None
    ) or (match.group(6) is not None and match.group(6) not in allowed_fmts):
        theme[match.group(1)] = colors[match.group(3)]
    else:
        theme[match.group(1)] = {'color': colors[match.group(3)]}
        if (
            match.group(4) is not None
            and code_style[match.group(4)] is not None
        ):
            theme[match.group(1)][code_style[match.group(4)]] = True
        elif match.group(6) in allowed_fmts:
            theme[match.group(1)][match.group(6)] = True

for key, value in additional_keys.items():
    theme[key] = value

with open('ts2tex.json', 'w') as config_file:
    json.dump(
        {
            'query_search_dirs': ['./deps/**/queries/'],
            'parser_search_dirs': [
                './deps/',
                './deps/ebnf/crates/',
            ],
            'theme': theme,
        },
        config_file,
        indent=2,
    )
