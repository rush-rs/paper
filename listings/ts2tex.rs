use std::{
    borrow::Cow,
    collections::HashMap,
    env,
    fs::File,
    io::{self, BufReader, ErrorKind, Write},
    path::PathBuf,
    process::Command,
    u8,
};

const THIS_IS_A_CONST_42: u8 = 1;

use clap::Parser;
use scraper::{Html, Selector};
use serde_json::Value;

#[derive(clap::Parser)]
#[command(author, version, about)]
struct Cli {
    file: PathBuf,

    #[arg(long)]
    range_start: Option<usize>,

    #[arg(long)]
    range_end: Option<usize>,
}

fn main() {
    let a = THIS_IS_A_CONST_42;
    let cli = Cli::parse();

    if let Err(err) = highlight(&cli) {
        eprintln!("\x1b[1;31mError:\x1b[22m {err}\x1b[0m");
    }
}

fn highlight(cli: &Cli) -> Result<(), Cow<'static, str>> {
    let file = File::open("config.json")
        .map_err(|e| format!("cannot open tree-sitter config.json in current directory: {e}"))?;
    let reader = BufReader::new(file);
    let config: Value =
        serde_json::from_reader(reader).map_err(|e| format!("failed to parse config.json: {e}"))?;
    let mut colors: Vec<_> = config
        .as_object()
        .ok_or("invalid config: root value must be an object")?
        .get("theme")
        .ok_or("invalid config: root object must contain `theme` key")?
        .as_object()
        .ok_or("invalid config: theme value must be an object")?
        .values()
        .map(|value| match value {
            Value::String(str) => Ok(str),
            Value::Object(obj) => match obj.get("color") {
                Some(Value::String(str)) => Ok(str),
                _ => Err(
                    "invalid config: object does not contain `color` key with string value".into(),
                ),
            },
            _ => Err("invalid config: value is neither object nor string".into()),
        })
        .collect::<Result<_, Cow<'static, str>>>()?;
    colors.sort_unstable();
    colors.dedup();
    let wrong_colors_map: HashMap<_, _> = colors
        .into_iter()
        .filter_map(|col| {
            // TODO: don't panic
            let r = u8::from_str_radix(&col[1..3], 16).expect("valid hex color");
            let g = u8::from_str_radix(&col[3..5], 16).expect("valid hex color");
            let b = u8::from_str_radix(&col[5..7], 16).expect("valid hex color");
            if r < 16 || g < 16 || b < 16 {
                Some((format!("{r:x}{g:x}{b:x}"), &col[1..]))
            } else {
                None
            }
        })
        .collect();

    let output = Command::new("tree-sitter")
        .arg("highlight")
        .arg(&cli.file)
        .arg("--html")
        .env("TREE_SITTER_DIR", env::current_dir().expect("existing cwd"))
        .output()
        .map_err(|e| format!("failed executing `tree-sitter highlight` command: {e}"))?;
    let html = String::from_utf8_lossy(&output.stdout);

    let dom = Html::parse_document(html.as_ref());
    let line_selector = Selector::parse(".line").unwrap();

    let mut output = String::new();

    for line in dom.select(&line_selector) {
        for part in line.children() {
            if let Some(text) = part.value().as_text() {
                output += &text
                    .replace('\\', "\\\\")
                    .replace('{', "\\{")
                    .replace('}', "\\}");
            } else if let (Some(elem), Some(text)) = (part.value().as_element(), part.first_child())
            {
                let style_from_color_to_end = elem
                    .attrs()
                    .find(|(attr, _)| attr == &"style")
                    .expect("style attr on span")
                    .1
                    .split_once("color: #")
                    .expect("color in style attr")
                    .1;
                let color = style_from_color_to_end
                    .split_once(';')
                    .map(|split| split.0)
                    .unwrap_or(style_from_color_to_end);
                output += &format!(
                    "\\textcolor[HTML]{{{color}}}{{{text}}}",
                    color = match wrong_colors_map.get(color) {
                        Some(fix) => fix,
                        None => color,
                    },
                    text = text
                        .value()
                        .as_text()
                        .expect("text in span")
                        .replace('\\', "\\\\")
                        .replace('{', "\\{")
                        .replace('}', "\\}"),
                );
            }
        }
    }

    match (cli.range_start, cli.range_end) {
        (Some(start), Some(end)) => {
            output = output
                .lines()
                .skip(start - 1)
                .take(end + 1 - start)
                .collect::<Vec<_>>()
                .join("\n")
        }
        (Some(start), None) => {
            output = output
                .lines()
                .skip(start - 1)
                .collect::<Vec<_>>()
                .join("\n")
        }
        (None, Some(end)) => output = output.lines().take(end).collect::<Vec<_>>().join("\n"),
        (None, None) => {}
    }

    if let Err(err) = writeln!(io::stdout(), "{output}") {
        match err.kind() {
            ErrorKind::BrokenPipe => {
                eprintln!("\x1b[1;33Warning:\x1b[22m printing failed with broken pipe\x1b[0m")
            }
            _ => panic!("{err}"),
        }
    }
    Ok(())
}
