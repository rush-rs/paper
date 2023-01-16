enum TokenKind {
    Number(u64),

    Plus,
    Minus,
    Star,
    Slash,
}

struct Token {
    kind: TokenKind,
    span: Span,
}

struct Span {
    start: Location,
    end: Location,
}
