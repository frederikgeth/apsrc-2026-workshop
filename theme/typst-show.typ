// Quarto template partial: applies the page set-up from layout.typ.
#show: program-doc.with(
  theme: theme,
  title: [$if(event.footer)$$event.footer$$else$$event.title$$endif$],
  footer: [$if(event.footer)$$event.footer$$else$$event.title$$endif$$if(event.date)$ · $event.date$$endif$],
  page-numbers: $if(hide-page-numbers)$false$else$true$endif$,
)
