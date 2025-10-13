; SQL injection for strings containing SELECT
((string_content) @injection.content
 (#match? @injection.content "(SELECT|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP)")
 (#set! injection.language "sql"))

; MDX injection for strings containing NON EMPTY or DIMENSION PROPERTIES
((string_content) @injection.content
 (#match? @injection.content "(NON EMPTY|DIMENSION PROPERTIES|FROM \\[)")
 (#set! injection.language "sql"))
