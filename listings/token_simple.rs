struct Token {
    kind: TokenKind,
    span: Span,
}

enum TokenKind {
    Int(u64),

    Plus,  // +
    Minus, // -
    Star,  // *
    Slash, // /
    Eq,    // ==
    Neq,   // !=
}

struct Span {
    start: Location,
    end: Location,
}
