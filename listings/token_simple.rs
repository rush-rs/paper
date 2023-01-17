struct Token {
    kind: TokenKind,
    span: Span,
}

enum TokenKind {
    Number(u64),

    Plus,
    Minus,
    Star,
    Slash,
}

struct Span {
    start: Location,
    end: Location,
}
